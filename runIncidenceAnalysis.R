#' Run MTXlab CohortIncidence Analysis
#'
#' @description
#' Executes the CohortIncidence analysis for the MTXlab study.
#'
#' @param connectionDetails Database connection details.
#' @param cdmDatabaseSchema CDM schema.
#' @param cohortDatabaseSchema Schema containing the cohort table.
#' @param cohortTable Name of the cohort table.
#' @param workDatabaseSchema Optional scratch schema for temp tables.
#' @param sourceName Database/source name.
#' @param refId Source reference ID.
#' @param outputFolder Optional folder to save results.
#'
#' @return A data frame containing incidence summary results.
#'
#' @export
runIncidenceAnalysis <- function(
    connectionDetails,
    cdmDatabaseSchema,
    cohortDatabaseSchema,
    cohortTable,
    workDatabaseSchema = cohortDatabaseSchema,
    sourceName,
    refId = 1,
    outputFolder = NULL
) {

  options(sqlRenderTempEmulationSchema = workDatabaseSchema)

  targetDefs <- list(
    CohortIncidence::createCohortRef(id = 24192, name = "Atopic Dermatitis"),
    CohortIncidence::createCohortRef(id = 24193, name = "Psoriasis"),
    CohortIncidence::createCohortRef(id = 24194, name = "Rheumatoid Arthritis"),
    CohortIncidence::createCohortRef(id = 24195, name = "Psoriatic Arthritis"),
    CohortIncidence::createCohortRef(id = 24196, name = "Crohn's Disease"),
    CohortIncidence::createCohortRef(id = 24607, name = "Ulcerative Colitis"),
    CohortIncidence::createCohortRef(id = 24197, name = "Overall")
  )

  outcomeDefs <- list(
    CohortIncidence::createOutcomeDef(id = 24180, name = "ALT", cohortId = 24180),
    CohortIncidence::createOutcomeDef(id = 24181, name = "eGFR", cohortId = 24181),
    CohortIncidence::createOutcomeDef(id = 24190, name = "Creatinine EU", cohortId = 24190),
    CohortIncidence::createOutcomeDef(id = 24191, name = "Creatinine USA", cohortId = 24191),
    CohortIncidence::createOutcomeDef(id = 24185, name = "Hemoglobin EU", cohortId = 24185),
    CohortIncidence::createOutcomeDef(id = 24186, name = "Hemoglobin USA", cohortId = 24186),
    CohortIncidence::createOutcomeDef(id = 24187, name = "Leucocytes EU", cohortId = 24187),
    CohortIncidence::createOutcomeDef(id = 24188, name = "Leucocytes USA", cohortId = 24188),
    CohortIncidence::createOutcomeDef(id = 24183, name = "Platelets", cohortId = 24183),
    CohortIncidence::createOutcomeDef(id = 24655, name = "Liver failure", cohortId = 24655),
    CohortIncidence::createOutcomeDef(id = 24656, name = "Kidney failure", cohortId = 24656),
    CohortIncidence::createOutcomeDef(id = 24657, name = "Anemia", cohortId = 24657),
    CohortIncidence::createOutcomeDef(id = 24658, name = "Leucopenia", cohortId = 24658),
    CohortIncidence::createOutcomeDef(id = 24659, name = "Thrombocytopenia", cohortId = 24659)
  )

  tarDefs <- list(
    CohortIncidence::createTimeAtRiskDef(
      id = 1,
      startWith = "start",
      startOffset = 0,
      endWith = "end",
      endOffset = 182
    ),
    CohortIncidence::createTimeAtRiskDef(
      id = 2,
      startWith = "start",
      startOffset = 182,
      endWith = "end",
      endOffset = 730
    ),
    CohortIncidence::createTimeAtRiskDef(
      id = 3,
      startWith = "start",
      startOffset = 730,
      endWith = "end",
      endOffset = 1825
    ),
    CohortIncidence::createTimeAtRiskDef(
      id = 4,
      startWith = "start",
      startOffset = 1825,
      endWith = "end",
      endOffset = 3650
    ),
    CohortIncidence::createTimeAtRiskDef(
      id = 5,
      startWith = "start",
      startOffset = 0,
      endWith = "end",
      endOffset = 3650
    )
  )

  incidenceAnalysis <- CohortIncidence::createIncidenceAnalysis(
    targets = c(
      24192, 24193, 24194, 24195,
      24196, 24607, 24197
    ),
    outcomes = c(
      24180, 24181, 24190, 24191,
      24185, 24186, 24187, 24188,
      24183, 24655, 24656, 24657,
      24658, 24659
    ),
    tars = c(1, 2, 3, 4, 5)
  )

  incidenceDesign <- CohortIncidence::createIncidenceDesign(
    targetDefs = targetDefs,
    outcomeDefs = outcomeDefs,
    tars = tarDefs,
    analysisList = list(incidenceAnalysis)
  )

  buildOptions <- CohortIncidence::buildOptions(
    cohortTable = cohortTable,
    outcomeCohortTable = cohortTable,
    cdmDatabaseSchema = cdmDatabaseSchema,
    sourceName = sourceName,
    refId = refId
  )

  results <- CohortIncidence::executeAnalysis(
    connectionDetails = connectionDetails,
    incidenceDesign = incidenceDesign,
    buildOptions = buildOptions
  )

  incidenceSummary <- results$incidence_summary
  incidenceSummary$Database <- sourceName

  if (!is.null(outputFolder)) {

    if (!dir.exists(outputFolder)) {
      dir.create(outputFolder, recursive = TRUE)
    }

    openxlsx::write.xlsx(
      incidenceSummary,
      file.path(
        outputFolder,
        paste0("IncidenceRates_", sourceName, ".xlsx")
      ),
      overwrite = TRUE
    )
  }

  return(incidenceSummary)
}
