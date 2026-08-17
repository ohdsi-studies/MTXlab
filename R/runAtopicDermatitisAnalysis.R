#' Run Atopic Dermatitis laboratory analysis
#'
#' @export
runAtopicDermatitisAnalysis <- function(
    connectionDetails,
    cdmDatabaseSchema,
    cdmDatabaseName,
    cohortDatabaseSchema,
    cohortTable,
    outcomeDatabaseSchema,
    outcomeTable
) {

  runPopulation <- function(
      targetId,
      outcomeId,
      laboratoryValue
  ) {

    databaseDetails <- PatientLevelPrediction::createDatabaseDetails(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cdmDatabaseName = cdmDatabaseName,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      outcomeDatabaseSchema = outcomeDatabaseSchema,
      outcomeTable = outcomeTable,
      targetId = targetId,
      outcomeIds = outcomeId,
      cdmVersion = 5,
      tempEmulationSchema = cohortDatabaseSchema
    )

    covariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsAge = TRUE,
      useDemographicsGender = TRUE,
      useConditionOccurrenceAnyTimePrior = TRUE
    )

    plpData <- PatientLevelPrediction::getPlpData(
      databaseDetails = databaseDetails,
      covariateSettings = covariateSettings,
      restrictPlpDataSettings = NULL
    )

    population <- PatientLevelPrediction::createStudyPopulation(
      plpData = plpData,
      outcomeId = plpData$metaData$databaseDetails$outcomeIds[1],
      populationSettings =
        PatientLevelPrediction::createStudyPopulationSettings(
          binary = TRUE,
          includeAllOutcomes = TRUE,
          firstExposureOnly = TRUE,
          washoutPeriod = 0,
          removeSubjectsWithPriorOutcome = TRUE,
          priorOutcomeLookback = 99999,
          requireTimeAtRisk = TRUE,
          minTimeAtRisk = 1,
          riskWindowStart = 0,
          startAnchor = "cohort start",
          riskWindowEnd = 3650,
          endAnchor = "cohort start",
          restrictTarToCohortEnd = TRUE
        ),
      population = NULL
    )

    population$Condition <- "Atopic dermatitis"
    population$Laboratoryvalue <- laboratoryValue

    return(population)
  }

  labDefinitions <- data.frame(
    targetId = c(
      24843, 24844, 24845, 24846,
      24847, 24848, 24849, 24850,
      24851
    ),
    outcomeId = c(
      24180, 24181, 24190, 24191,
      24185, 24186, 24187, 24188,
      24183
    ),
    laboratoryValue = c(
      "ALT (150 - 1000 U/L)",
      "eGFR (10 - 45 mL/min/1.73m²)",
      "Creatinine EU (125 - 500 μmol/L)",
      "Creatinine USA (125 - 500 μmol/L)",
      "Hemoglobin EU (2 - 6 mmol/L)",
      "Hemoglobin USA (2 - 6 mmol/L)",
      "Leucocytes EU (0.5 - 2.0 x 10⁹/L)",
      "Leucocytes USA (0.5 - 2.0 x 10⁹/L)",
      "Platelets (10 - 100 x 10⁹/L)"
    ),
    stringsAsFactors = FALSE
  )

  populations <- lapply(
    seq_len(nrow(labDefinitions)),
    function(i) {
      runPopulation(
        targetId = labDefinitions$targetId[i],
        outcomeId = labDefinitions$outcomeId[i],
        laboratoryValue = labDefinitions$laboratoryValue[i]
      )
    }
  )

  populationAD <- dplyr::bind_rows(populations)

  populationAD$Database <- cdmDatabaseName

  sfit <- survival::survfit(
    survival::Surv(
      survivalTime,
      outcomeCount
    ) ~ interaction(Laboratoryvalue, Database),
    data = populationAD
  )

  surv_tab <- survminer::surv_summary(
    sfit,
    data = populationAD
  ) %>%
    tidyr::separate(
      strata,
      into = c("ignore", "grp"),
      sep = "=",
      fill = "right",
      extra = "merge"
    ) %>%
    tidyr::separate(
      grp,
      into = c("Laboratoryvalue", "Database"),
      sep = "\\.",
      fill = "right",
      extra = "merge"
    ) %>%
    dplyr::select(
      time,
      surv,
      lower,
      upper,
      n.risk,
      n.event,
      n.censor,
      Laboratoryvalue,
      Database
    ) %>%
    dplyr::mutate(
      Laboratoryvalue = as.factor(Laboratoryvalue),
      Database = as.factor(Database)
    )

  readr::write_csv(
surv_tab,
file.path(outputFolder, "survtabAD.csv"
)

  return(surv_tab)
}
