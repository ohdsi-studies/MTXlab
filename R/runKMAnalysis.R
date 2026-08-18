#' Run KM analysis
#'
#' @details
#' The user specifies 
#'
#' @param connectionDetails
#' @param cdmDatabaseSchema
#' @param cdmDatabaseName
#' @param cohortDatabaseSchema
#' @param cohortTable
#' @param outcomeDatabaseSchema
#' @param outcomeTable
#' @param outputFolder
#'
#' @return
#' a data frame
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
    outputFolder = "."
) {

  runPopulation <- function(
      targetId,
      outcomeId,
      laboratoryValue,
      condition
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

        if (is.null(population) || nrow(population) == 0) {
         return(NULL)
        }

    population$Condition <- condition
    population$Laboratoryvalue <- laboratoryValue

    return(population)
  }

  conditions <- unique(.KMDefinitions$condition)

  results <- list()

  for (condition in conditions) {

    message("Running: ", condition)

    selectedLabs <- .KMDefinitions[
      .KMDefinitions$condition == condition,
    ]

    populations <- lapply(
      seq_len(nrow(selectedLabs)),
      function(i) {

        tryCatch(
          {
            runPopulation(
              targetId = selectedLabs$targetId[i],
              outcomeId = selectedLabs$outcomeId[i],
              laboratoryValue = selectedLabs$laboratoryValue[i],
              condition = condition
            )
          },
          error = function(e) {

            warning(
              paste0(
                "Failed for condition='", condition,
                "', targetId=", selectedLabs$targetId[i],
                ", outcomeId=", selectedLabs$outcomeId[i],
                ". Error: ", e$message
              )
            )

            NULL
          }
        )
      }
    )

    populations <- Filter(Negate(is.null), populations)

    if (length(populations) == 0) {
      warning(
        "No eligible populations found for condition: ",
        condition
      )
      next
    }

    populationData <- dplyr::bind_rows(populations)

    if (nrow(populationData) == 0) {
      warning(
        "No population data available for condition: ",
        condition
      )
      next
    }

    populationData$Database <- cdmDatabaseName

    sfit <- tryCatch(
      {
        survival::survfit(
          survival::Surv(
            survivalTime,
            outcomeCount
          ) ~ interaction(
            Laboratoryvalue,
            Database,
            sep = "___"
          ),
          data = populationData
        )
      },
      error = function(e) {

        warning(
          paste0(
            "KM fit failed for condition='",
            condition,
            "'. Error: ",
            e$message
          )
        )

        NULL
      }
    )

    if (is.null(sfit)) {
      next
    }

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
        sep = "___",
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

    results[[condition]] <- surv_tab

    message(
      "Saved results for ",
      condition,
      " to ",
      fileName
    )
  }

  return(results)
}
