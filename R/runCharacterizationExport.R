#' Run Characterization Analyses
#'
#' Executes the predefined characterization analyses and exports
#' the results to the specified output directory.
#'
#' @param connectionDetails DatabaseConnector connection details.
#' @param cdmDatabaseSchema OMOP CDM schema.
#' @param targetDatabaseSchema Schema containing the target cohort table.
#' @param targetTable Name of the target cohort table.
#' @param outcomeDatabaseSchema Schema containing the outcome cohort table.
#' @param outcomeTable Name of the outcome cohort table.
#' @param outputDirectory Folder where results will be written.
#' @param executionPath Folder used for execution tracking.
#' @param csvFilePrefix Prefix for all generated CSV files.
#' @param databaseId Unique identifier for the contributing database.
#'
#' @return Characterization results object.
#' @export
runCharacterizationExport <- function(
    connectionDetails,
    cdmDatabaseSchema,
    targetDatabaseSchema,
    targetTable,
    outcomeDatabaseSchema,
    outcomeTable,
    outputDirectory,
    executionPath,
    csvFilePrefix,
    databaseId 
) {

  # Fixed study cohorts
  targetIds <- c(
    24769, 24770, 24771,
    24772, 24773, 24774
  )

  outcomeIds <- c(
    24180, 24181, 24190, 24191,
    24185, 24186, 24187, 24188,
    24183, 24655, 24656, 24657,
    24658, 24659
  )

 covariateIds <- c(18778, 24936, 19285, 21288, 21287, 24934, 24935, 24933, 24655, 24656)
  
  covariateSettings <- FeatureExtraction::createCovariateSettings(
    useDemographicsGender = TRUE,
    useDemographicsAge = TRUE,
    useDemographicsAgeGroup = TRUE,
    useDemographicsRace = TRUE,
    useDemographicsEthnicity = TRUE,
    useDemographicsIndexYearMonth = TRUE,
    useConditionOccurrenceAnyTimePrior = TRUE,
    useDrugExposureAnyTimePrior = TRUE,
    useMeasurementAnyTimePrior = TRUE,
    useMeasurementValueAnyTimePrior = TRUE,
    useMeasurementValueLongTerm = TRUE,
    useObservationAnyTimePrior = TRUE,
    useObservationValueAsConceptAnyTimePrior = TRUE,
    useObservationValueAnyTimePrior = TRUE,
    endDays = 0,
    addDescendantsToInclude = TRUE,
    addDescendantsToExclude = TRUE,
    includedCovariateIds = covariateIds
  )

  riskFactorSettings <- Characterization::createRiskFactorSettings(
    targetIds = targetIds,
    outcomeIds = outcomeIds,
    limitToFirstInNDays = 99999,
    riskWindowStart = 0,
    startAnchor = "cohort start",
    riskWindowEnd = 1825,
    endAnchor = "cohort start",
    outcomeWashoutDays = 9999,
    minPriorObservation = 365,
    covariateSettings = covariateSettings
  )

  dechallengeRechallengeSettings <-
    Characterization::createDechallengeRechallengeSettings(
      targetIds = targetIds,
      outcomeIds = outcomeIds,
      dechallengeStopInterval = 30,
      dechallengeEvaluationWindow = 31
    )

  timeToEventSettings <- Characterization::createTimeToEventSettings(
    targetIds = targetIds,
    outcomeIds = outcomeIds
  )

  characterizationSettings <-
    Characterization::createCharacterizationSettings(
      timeToEventSettings = list(timeToEventSettings),
      dechallengeRechallengeSettings =
        list(dechallengeRechallengeSettings),
      riskFactorSettings = list(riskFactorSettings)
    )

  results <- Characterization::runCharacterizationAnalyses(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    targetDatabaseSchema = targetDatabaseSchema,
    targetTable = targetTable,
    outcomeDatabaseSchema = outcomeDatabaseSchema,
    outcomeTable = outcomeTable,
    characterizationSettings = characterizationSettings,
    outputDirectory = outputDirectory,
    executionPath = executionPath,
    csvFilePrefix = csvFilePrefix,
    databaseId = databaseId,
    incremental = FALSE,
    minCharacterizationMean = 0.00001,
    minCellCount = 5
  )

  return(results)
}
