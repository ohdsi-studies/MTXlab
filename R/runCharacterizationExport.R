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
  useDemographicsGender = TRUE,
  useDemographicsAge = TRUE,
  useDemographicsAgeGroup = TRUE,
  useDemographicsRace = TRUE,
  useDemographicsEthnicity = TRUE,
  useDemographicsIndexYear = TRUE,
  useDemographicsIndexMonth = TRUE,
  useDemographicsPriorObservationTime = TRUE,
  useDemographicsPostObservationTime = TRUE,
  useDemographicsTimeInCohort = TRUE,
  useDemographicsIndexYearMonth = TRUE,
  useConditionOccurrenceAnyTimePrior = TRUE,
  useConditionOccurrenceLongTerm = TRUE,
  useConditionOccurrenceMediumTerm = TRUE,
  useConditionOccurrenceShortTerm = TRUE,
  useConditionOccurrencePrimaryInpatientAnyTimePrior = TRUE,
  useConditionOccurrencePrimaryInpatientLongTerm = TRUE,
  useConditionOccurrencePrimaryInpatientMediumTerm = TRUE,
  useConditionOccurrencePrimaryInpatientShortTerm = TRUE,
  useConditionEraAnyTimePrior = TRUE,
  useConditionEraLongTerm = TRUE,
  useConditionEraMediumTerm = TRUE,
  useConditionEraShortTerm = TRUE,
  useConditionEraOverlapping = TRUE,
  useConditionEraStartLongTerm = TRUE,
  useConditionEraStartMediumTerm = TRUE,
  useConditionEraStartShortTerm = TRUE,
  useConditionGroupEraAnyTimePrior = TRUE,
  useConditionGroupEraLongTerm = TRUE,
  useConditionGroupEraMediumTerm = TRUE,
  useConditionGroupEraShortTerm = TRUE,
  useConditionGroupEraOverlapping = TRUE,
  useConditionGroupEraStartLongTerm = TRUE,
  useConditionGroupEraStartMediumTerm = TRUE,
  useConditionGroupEraStartShortTerm = TRUE,
  useDrugExposureAnyTimePrior = TRUE,
  useDrugExposureLongTerm = TRUE,
  useDrugExposureMediumTerm = TRUE,
  useDrugExposureShortTerm = TRUE,
  useDrugEraAnyTimePrior = TRUE,
  useDrugEraLongTerm = TRUE,
  useDrugEraMediumTerm = TRUE,
  useDrugEraShortTerm = TRUE,
  useDrugEraOverlapping = TRUE,
  useDrugEraStartLongTerm = TRUE,
  useDrugEraStartMediumTerm = TRUE,
  useDrugEraStartShortTerm = TRUE,
  useDrugGroupEraAnyTimePrior = TRUE,
  useDrugGroupEraLongTerm = TRUE,
  useDrugGroupEraMediumTerm = TRUE,
  useDrugGroupEraShortTerm = TRUE,
  useDrugGroupEraOverlapping = TRUE,
  useDrugGroupEraStartLongTerm = TRUE,
  useDrugGroupEraStartMediumTerm = TRUE,
  useDrugGroupEraStartShortTerm = TRUE,
  useProcedureOccurrenceAnyTimePrior = TRUE,
  useProcedureOccurrenceLongTerm = TRUE,
  useProcedureOccurrenceMediumTerm = TRUE,
  useProcedureOccurrenceShortTerm = TRUE,
  useDeviceExposureAnyTimePrior = TRUE,
  useDeviceExposureLongTerm = TRUE,
  useDeviceExposureMediumTerm = TRUE,
  useDeviceExposureShortTerm = TRUE,
  useMeasurementAnyTimePrior = TRUE,
  useMeasurementLongTerm = TRUE,
  useMeasurementMediumTerm = TRUE,
  useMeasurementShortTerm = TRUE,
  useMeasurementValueAnyTimePrior = TRUE,
  useMeasurementValueLongTerm = TRUE,
  useMeasurementValueMediumTerm = TRUE,
  useMeasurementValueShortTerm = TRUE,
  useMeasurementRangeGroupAnyTimePrior = TRUE,
  useMeasurementRangeGroupLongTerm = TRUE,
  useMeasurementRangeGroupMediumTerm = TRUE,
  useMeasurementRangeGroupShortTerm = TRUE,
  useMeasurementValueAsConceptAnyTimePrior = TRUE,
  useMeasurementValueAsConceptLongTerm = TRUE,
  useMeasurementValueAsConceptMediumTerm = TRUE,
  useMeasurementValueAsConceptShortTerm = TRUE,
  useObservationAnyTimePrior = TRUE,
  useObservationLongTerm = TRUE,
  useObservationMediumTerm = TRUE,
  useObservationShortTerm = TRUE,
  useObservationValueAsConceptAnyTimePrior = TRUE,
  useObservationValueAsConceptLongTerm = TRUE,
  useObservationValueAsConceptMediumTerm = TRUE,
  useObservationValueAsConceptShortTerm = TRUE,
  useObservationValueAnyTimePrior = TRUE,
  useObservationValueLongTerm = TRUE,
  useObservationValueMediumTerm = TRUE,
  useObservationValueShortTerm = TRUE,
  useCharlsonIndex = TRUE,
  useDcsi = TRUE,
  useChads2 = TRUE,
  useChads2Vasc = TRUE,
  useHfrs = TRUE,
  useDistinctConditionCountLongTerm = TRUE,
  useDistinctConditionCountMediumTerm = TRUE,
  useDistinctConditionCountShortTerm = TRUE,
  useDistinctIngredientCountLongTerm = TRUE,
  useDistinctIngredientCountMediumTerm = TRUE,
  useDistinctIngredientCountShortTerm = TRUE,
  useDistinctProcedureCountLongTerm = TRUE,
  useDistinctProcedureCountMediumTerm = TRUE,
  useDistinctProcedureCountShortTerm = TRUE,
  useDistinctMeasurementCountLongTerm = TRUE,
  useDistinctMeasurementCountMediumTerm = TRUE,
  useDistinctMeasurementCountShortTerm = TRUE,
  useDistinctObservationCountLongTerm = TRUE,
  useDistinctObservationCountMediumTerm = TRUE,
  useDistinctObservationCountShortTerm = TRUE,
  useVisitCountLongTerm = TRUE,
  useVisitCountMediumTerm = TRUE,
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
