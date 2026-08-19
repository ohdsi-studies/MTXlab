#' Calculate Lab Follow Up
#'
#' @details
#' The user specifies 
#'
#' @param con the connection by means of connectionDetails
#' @param workDatabaseSchema
#' @param cohortTabl the cohort table name
#' @param cdmDatabaseSchema 
#'
#' @return
#' a data frame
#' 
#' @export
calculateLabFollowUp <- function(con,
                                 workDatabaseSchema,
                                 cohortTable,
                                 cdmDatabaseSchema,
                                 labName,
                                 cohortDefinitionId,
                                 ancestorConceptId,
                                 abnormalLowerLimit,
                                 abnormalUpperLimit,
                                 plausibleLowerLimit,
                                 plausibleUpperLimit) {
  
  results <- list()
  
  for (startMonth in seq(0, 114, by = 6)) {
    
    endMonth <- startMonth + 6
    
    # Patients still exposed and in data
    labCohort <- querySql(
      con,
      paste0(
        "
SELECT COUNT(DISTINCT subject_id) AS n
FROM ", workDatabaseSchema, ".", cohortTable, "
WHERE cohort_definition_id = ", cohortDefinitionId, "
AND cohort_end_date >= cohort_start_date + INTERVAL '",
        startMonth,
        " MONTHS';
"
      )
    )
    
    nExposed <- labCohort$n
    
    # Overall lab values
    overallLabValues <- querySql(
      con,
      paste0(
        "
SELECT
c.subject_id,
c.cohort_start_date,
c.cohort_end_date,
m.measurement_date,
m.measurement_concept_id,
m.value_as_number,
m.unit_concept_id
FROM ",
        workDatabaseSchema, ".", cohortTable, " c
JOIN ",
        cdmDatabaseSchema, ".measurement m
ON c.subject_id = m.person_id
WHERE c.cohort_definition_id = ", cohortDefinitionId, "
AND m.measurement_concept_id IN (
SELECT descendant_concept_id
FROM ", cdmDatabaseSchema, ".concept_ancestor
WHERE ancestor_concept_id = ", ancestorConceptId, "
)
AND m.value_as_number IS NOT NULL
AND m.value_as_number >= ",plausibleLowerLimit,"
AND m.value_as_number <= ",plausibleUpperLimit,"
AND m.measurement_date >= c.cohort_start_date + INTERVAL '",
      startMonth,
      " MONTHS'
AND m.measurement_date < c.cohort_start_date + INTERVAL '",
      endMonth,
      " MONTHS'
AND m.measurement_date <= c.cohort_end_date;
"
      )
    )

# Patients with at least one measurement
patientsWithMeasurement <- dplyr::n_distinct(
  overallLabValues$subject_id
)

# Missingness
missingPatients <- nExposed - patientsWithMeasurement

missingPercentage <- ifelse(
  nExposed > 0,
  100 * missingPatients / nExposed,
  NA
)

# Number of measurements per patient
labCounts <- overallLabValues %>%
  dplyr::count(subject_id, name = "nLab")

medianLabPerPatient <- if (nrow(labCounts) > 0) {
  median(labCounts$nLab, na.rm = TRUE)
} else {
  NA
}

q1LabPerPatient <- if (nrow(labCounts) > 0) {
  quantile(
    labCounts$nLab,
    probs = 0.25,
    na.rm = TRUE
  )
} else {
  NA
}

q3LabPerPatient <- if (nrow(labCounts) > 0) {
  quantile(
    labCounts$nLab,
    probs = 0.75,
    na.rm = TRUE
  )
} else {
  NA
}

meanLabPerPatient <- if (nrow(labCounts) > 0) {
  mean(labCounts$nLab, na.rm = TRUE)
} else {
  NA
}

sdLabPerPatient <- if (nrow(labCounts) > 1) {
  sd(labCounts$nLab, na.rm = TRUE)
} else {
  NA
}

# Lab value distribution
medianLab <- if (nrow(overallLabValues) > 0) {
  median(overallLabValues$value_as_number, na.rm = TRUE)
} else {
  NA
}

q1Lab <- if (nrow(overallLabValues) > 0) {
  quantile(
    overallLabValues$value_as_number,
    probs = 0.25,
    na.rm = TRUE
  )
} else {
  NA
}

q3Lab <- if (nrow(overallLabValues) > 0) {
  quantile(
    overallLabValues$value_as_number,
    probs = 0.75,
    na.rm = TRUE
  )
} else {
  NA
}

meanLab <- if (nrow(overallLabValues) > 0) {
  mean(overallLabValues$value_as_number, na.rm = TRUE)
} else {
  NA
}

sdLab <- if (nrow(overallLabValues) > 1) {
  sd(overallLabValues$value_as_number, na.rm = TRUE)
} else {
  NA
}

# Abnormal patients
abnormalPatients <- overallLabValues %>%
  dplyr::filter(
    value_as_number >= abnormalLowerLimit,
    value_as_number <= abnormalUpperLimit
  ) %>%
  dplyr::distinct(subject_id)

nAbnormalPatients <- nrow(abnormalPatients)

# Results
results[[paste0(startMonth, "_", endMonth)]] <- data.frame(
  Lab = labName,
  Interval = paste0(startMonth, "-", endMonth, " months"),
  
  CohortPatients = nExposed,
  PatientsWithMeasurement = patientsWithMeasurement,
  MissingPatients = missingPatients,
  MissingPct = round(missingPercentage, 2),
  
  MedianMeasurementsPerPatient = medianLabPerPatient,
  Q1MeasurementsPerPatient = q1LabPerPatient,
  Q3MeasurementsPerPatient = q3LabPerPatient,
  MeanMeasurementsPerPatient = meanLabPerPatient,
  SDMeasurementsPerPatient = sdLabPerPatient,
  
  MedianLabValue = medianLab,
  Q1LabValue = q1Lab,
  Q3LabValue = q3Lab,
  MeanLabValue = meanLab,
  SDLabValue = sdLab,
  
  AbnormalPatients = nAbnormalPatients
)
  }
  
  dplyr::bind_rows(results)
}

