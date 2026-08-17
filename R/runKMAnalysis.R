#' Run KM analysis
#'
#' @export
runKMAnalysis <- function(
    connectionDetails,
    cdmDatabaseSchema,
    cdmDatabaseName,
    cohortDatabaseSchema,
    cohortTable,
    outcomeDatabaseSchema,
    outcomeTable,
    condition,
    outputFolder = "."
) {

  selectedLabs <- .KMDefinitions[
    .KMDefinitions$condition == condition,
  ]

  if (nrow(selectedLabs) == 0) {
    stop(
      paste(
        "No laboratory definitions found for condition:",
        condition
      )
    )
  }

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

    population$Condition <- condition
    population$Laboratoryvalue <- laboratoryValue

    return(population)
  }

  populations <- lapply(
    seq_len(nrow(selectedLabs)),
    function(i) {
      runPopulation(
        targetId = selectedLabs$targetId[i],
        outcomeId = selectedLabs$outcomeId[i],
        laboratoryValue = selectedLabs$laboratoryValue[i]
      )
    }
  )

  populationData <- dplyr::bind_rows(populations)

  populationData$Database <- cdmDatabaseName

  sfit <- survival::survfit(
    survival::Surv(
      survivalTime,
      outcomeCount
    ) ~ interaction(
      Laboratoryvalue,
      Database
    ),
    data = populationData
  )

  surv_tab <- survminer::surv_summary(
    sfit,
    data = populationData
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

  fileName <- paste0(
    "survtab_",
    gsub("[^A-Za-z0-9]", "", condition),
    ".csv"
  )

  readr::write_csv(
    surv_tab,
    file.path(outputFolder, fileName)
  )

  return(surv_tab)
}
