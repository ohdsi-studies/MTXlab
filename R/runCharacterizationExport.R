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
    executionPath
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
  useDemographicsGender = FALSE,
  useDemographicsAge = FALSE,
  useDemographicsAgeGroup = FALSE,
  useDemographicsRace = FALSE,
  useDemographicsEthnicity = FALSE,
  useDemographicsIndexYear = FALSE,
  useDemographicsIndexMonth = FALSE,
  useDemographicsPriorObservationTime = FALSE,
  useDemographicsPostObservationTime = FALSE,
  useDemographicsTimeInCohort = FALSE,
  useDemographicsIndexYearMonth = FALSE,
  useConditionOccurrenceAnyTimePrior = FALSE,
  useConditionOccurrenceLongTerm = FALSE,
  useConditionOccurrenceMediumTerm = FALSE,
  useConditionOccurrenceShortTerm = FALSE,
  useConditionOccurrencePrimaryInpatientAnyTimePrior = FALSE,
  useConditionOccurrencePrimaryInpatientLongTerm = FALSE,
  useConditionOccurrencePrimaryInpatientMediumTerm = FALSE,
  useConditionOccurrencePrimaryInpatientShortTerm = FALSE,
  useConditionEraAnyTimePrior = FALSE,
  useConditionEraLongTerm = FALSE,
  useConditionEraMediumTerm = FALSE,
  useConditionEraShortTerm = FALSE,
  useConditionEraOverlapping = FALSE,
  useConditionEraStartLongTerm = FALSE,
  useConditionEraStartMediumTerm = FALSE,
  useConditionEraStartShortTerm = FALSE,
  useConditionGroupEraAnyTimePrior = FALSE,
  useConditionGroupEraLongTerm = FALSE,
  useConditionGroupEraMediumTerm = FALSE,
  useConditionGroupEraShortTerm = FALSE,
  useConditionGroupEraOverlapping = FALSE,
  useConditionGroupEraStartLongTerm = FALSE,
  useConditionGroupEraStartMediumTerm = FALSE,
  useConditionGroupEraStartShortTerm = FALSE,
  useDrugExposureAnyTimePrior = FALSE,
  useDrugExposureLongTerm = FALSE,
  useDrugExposureMediumTerm = FALSE,
  useDrugExposureShortTerm = FALSE,
  useDrugEraAnyTimePrior = FALSE,
  useDrugEraLongTerm = FALSE,
  useDrugEraMediumTerm = FALSE,
  useDrugEraShortTerm = FALSE,
  useDrugEraOverlapping = FALSE,
  useDrugEraStartLongTerm = FALSE,
  useDrugEraStartMediumTerm = FALSE,
  useDrugEraStartShortTerm = FALSE,
  useDrugGroupEraAnyTimePrior = FALSE,
  useDrugGroupEraLongTerm = FALSE,
  useDrugGroupEraMediumTerm = FALSE,
  useDrugGroupEraShortTerm = FALSE,
  useDrugGroupEraOverlapping = FALSE,
  useDrugGroupEraStartLongTerm = FALSE,
  useDrugGroupEraStartMediumTerm = FALSE,
  useDrugGroupEraStartShortTerm = FALSE,
  useProcedureOccurrenceAnyTimePrior = FALSE,
  useProcedureOccurrenceLongTerm = FALSE,
  useProcedureOccurrenceMediumTerm = FALSE,
  useProcedureOccurrenceShortTerm = FALSE,
  useDeviceExposureAnyTimePrior = FALSE,
  useDeviceExposureLongTerm = FALSE,
  useDeviceExposureMediumTerm = FALSE,
  useDeviceExposureShortTerm = FALSE,
  useMeasurementAnyTimePrior = FALSE,
  useMeasurementLongTerm = FALSE,
  useMeasurementMediumTerm = FALSE,
  useMeasurementShortTerm = FALSE,
  useMeasurementValueAnyTimePrior = FALSE,
  useMeasurementValueLongTerm = FALSE,
  useMeasurementValueMediumTerm = FALSE,
  useMeasurementValueShortTerm = FALSE,
  useMeasurementRangeGroupAnyTimePrior = FALSE,
  useMeasurementRangeGroupLongTerm = FALSE,
  useMeasurementRangeGroupMediumTerm = FALSE,
  useMeasurementRangeGroupShortTerm = FALSE,
  useMeasurementValueAsConceptAnyTimePrior = FALSE,
  useMeasurementValueAsConceptLongTerm = FALSE,
  useMeasurementValueAsConceptMediumTerm = FALSE,
  useMeasurementValueAsConceptShortTerm = FALSE,
  useObservationAnyTimePrior = FALSE,
  useObservationLongTerm = FALSE,
  useObservationMediumTerm = FALSE,
  useObservationShortTerm = FALSE,
  useObservationValueAsConceptAnyTimePrior = FALSE,
  useObservationValueAsConceptLongTerm = FALSE,
  useObservationValueAsConceptMediumTerm = FALSE,
  useObservationValueAsConceptShortTerm = FALSE,
  useObservationValueAnyTimePrior = FALSE,
  useObservationValueLongTerm = FALSE,
  useObservationValueMediumTerm = FALSE,
  useObservationValueShortTerm = FALSE,
  useCharlsonIndex = FALSE,
  useDcsi = FALSE,
  useChads2 = FALSE,
  useChads2Vasc = FALSE,
  useHfrs = FALSE,
  useDistinctConditionCountLongTerm = FALSE,
  useDistinctConditionCountMediumTerm = FALSE,
  useDistinctConditionCountShortTerm = FALSE,
  useDistinctIngredientCountLongTerm = FALSE,
  useDistinctIngredientCountMediumTerm = FALSE,
  useDistinctIngredientCountShortTerm = FALSE,
  useDistinctProcedureCountLongTerm = FALSE,
  useDistinctProcedureCountMediumTerm = FALSE,
  useDistinctProcedureCountShortTerm = FALSE,
  useDistinctMeasurementCountLongTerm = FALSE,
  useDistinctMeasurementCountMediumTerm = FALSE,
  useDistinctMeasurementCountShortTerm = FALSE,
  useDistinctObservationCountLongTerm = FALSE,
  useDistinctObservationCountMediumTerm = FALSE,
  useDistinctObservationCountShortTerm = FALSE,
  useVisitCountLongTerm = FALSE,
  useVisitCountMediumTerm = FALSE,
  useVisitCountShortTerm = TRUE,
  useVisitConceptCountLongTerm = TRUE,
  useVisitConceptCountMediumTerm = TRUE,
  useVisitConceptCountShortTerm = TRUE,
  longTermStartDays = -365, 
  mediumTermStartDays = -180, 
  shortTermStartDays = -30, 
  endDays = 0,
  addDescendantsToInclude = FALSE,
  addDescendantsToExclude = FALSE,
  includedCovariateConceptIds = covariateIds
  )

  targetBaselineSettings <- createTargetBaselineSettings(
      studyPopulationSettings = createStudyPopulationSettings(
        targetIds = targetIds,
        limitToFirstInNDays = 99999,
        minPriorObservation = 365
  ),
  covariateSettings = covariateSettings
)

  riskFactorSettings <- Characterization::createRiskFactorSettings(
    studyPopulationSettings = Characterization::createStudyPopulationSettings(
    targetIds = targetIds,
    limitToFirstInNDays = 99999,
    minPriorObservation = 365
    ),
    outcomeIds = outcomeIds,
    riskWindowStart = 0,
    startAnchor = "cohort start",
    riskWindowEnd = 1825,
    endAnchor = "cohort start",
    outcomeWashoutDays = 365,
    covariateSettings = covariateSettings
  )

  dechallengeRechallengeSettings <-
    Characterization::createDechallengeRechallengeSettings(
      studyPopulationSettings = Characterization::createStudyPopulationSettings(
      targetIds = targetIds
      ),
      outcomeIds = outcomeIds,
      dechallengeStopInterval = 30,
      dechallengeEvaluationWindow = 31
    )

  timeToEventSettings <- Characterization::createTimeToEventSettings(
    studyPopulationSettings = Characterization::createStudyPopulationSettings(
    targetIds = targetIds
    ),
    outcomeIds = outcomeIds
  )

  characterizationSettings <-
    Characterization::createCharacterizationSettings(
      targetBaselineSettings = list(targetBaselineSettings),
      timeToEventSettings = list(timeToEventSettings),
      dechallengeRechallengeSettings =
        list(dechallengeRechallengeSettings),
      riskFactorSettings = list(riskFactorSettings)
    )

#Create Characterization subfolder
    characterizationOutputDirectory <- file.path(
        outputDirectory, 
        "Characterization"
        )

    if (!dir.exists(characterizationOutputDirectory)) {
        dir.create(characterizationOutputDirectory,
                   recursive = TRUE)
        }
    
  results <- Characterization::runCharacterizationAnalyses(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    targetDatabaseSchema = targetDatabaseSchema,
    targetTable = targetTable,
    outcomeDatabaseSchema = outcomeDatabaseSchema,
    outcomeTable = outcomeTable,
    characterizationSettings = characterizationSettings,
    outputDirectory = characterizationOutputDirectory,
    executionPath = executionPath,
    csvFilePrefix = "c_,
    databaseId = "1",
    incremental = FALSE,
    minCharacterizationMean = 0.00001,
    minCellCount = 5
  )

  return(results)
}
