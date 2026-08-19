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
      CohortIncidence::createCohortRef(id = 24843, name = "Atopic Dermatitis ALT"),
      CohortIncidence::createCohortRef(id = 24844, name = "Atopic Dermatitis eGFR"),
      CohortIncidence::createCohortRef(id = 24845, name = "Atopic Dermatitis Creatinine EU"),
      CohortIncidence::createCohortRef(id = 24846, name = "Atopic Dermatitis Creatinine USA"),
      CohortIncidence::createCohortRef(id = 24847, name = "Atopic Dermatitis Hemoglobin EU"),
      CohortIncidence::createCohortRef(id = 24848, name = "Atopic Dermatitis Hemoglobin USA"),
      CohortIncidence::createCohortRef(id = 24849, name = "Atopic Dermatitis Leucocytes EU"),
      CohortIncidence::createCohortRef(id = 24850, name = "Atopic Dermatitis Leucocytes USA"),
      CohortIncidence::createCohortRef(id = 24851, name = "Atopic Dermatitis Platelets"),
      CohortIncidence::createCohortRef(id = 24852, name = "Psoriasis ALT"),
      CohortIncidence::createCohortRef(id = 24853, name = "Psoriasis eGFR"),
      CohortIncidence::createCohortRef(id = 24854, name = "Psoriasis Creatinine EU"),
      CohortIncidence::createCohortRef(id = 24886, name = "Psoriasis Creatinine USA"),
      CohortIncidence::createCohortRef(id = 24887, name = "Psoriasis Hemoglobin EU"),
      CohortIncidence::createCohortRef(id = 24888, name = "Psoriasis Hemoglobin USA"),
      CohortIncidence::createCohortRef(id = 24889, name = "Psoriasis Leucocytes EU"),
      CohortIncidence::createCohortRef(id = 24890, name = "Psoriasis Leucocytes USA"),
      CohortIncidence::createCohortRef(id = 24891, name = "Psoriasis Platelets"),
      CohortIncidence::createCohortRef(id = 24892, name = "Rheumatoid Arthritis ALT"),
      CohortIncidence::createCohortRef(id = 24893, name = "Rheumatoid Arthritis eGFR"),
      CohortIncidence::createCohortRef(id = 24894, name = "Rheumatoid Arthritis Creatinine EU"),
      CohortIncidence::createCohortRef(id = 24895, name = "Rheumatoid Arthritis Creatinine USA"),
      CohortIncidence::createCohortRef(id = 24896, name = "Rheumatoid Arthritis Hemoglobin EU"),
      CohortIncidence::createCohortRef(id = 24897, name = "Rheumatoid Arthritis Hemoglobin USA"),
      CohortIncidence::createCohortRef(id = 24898, name = "Rheumatoid Arthritis Leucocytes EU"),
      CohortIncidence::createCohortRef(id = 24899, name = "Rheumatoid Arthritis Leucocytes USA"),
      CohortIncidence::createCohortRef(id = 24900, name = "Rheumatoid Arthritis Platelets"),
      CohortIncidence::createCohortRef(id = 24901, name = "Psoriatic Arthritis ALT"),
      CohortIncidence::createCohortRef(id = 24902, name = "Psoriatic Arthritis eGFR"),
      CohortIncidence::createCohortRef(id = 24903, name = "Psoriatic Arthritis Creatinine EU"),
      CohortIncidence::createCohortRef(id = 24904, name = "Psoriatic Arthritis Creatinine USA"),
      CohortIncidence::createCohortRef(id = 24905, name = "Psoriatic Arthritis Hemoglobin EU"),
      CohortIncidence::createCohortRef(id = 24906, name = "Psoriatic Arthritis Hemoglobin USA"),
      CohortIncidence::createCohortRef(id = 24907, name = "Psoriatic Arthritis Leucocytes EU"),
      CohortIncidence::createCohortRef(id = 24908, name = "Psoriatic Arthritis Leucocytes USA"),
      CohortIncidence::createCohortRef(id = 24909, name = "Psoriatic Arthritis Platelets"),
      CohortIncidence::createCohortRef(id = 24910, name = "Crohn's Disease ALT"),
      CohortIncidence::createCohortRef(id = 24911, name = "Crohn's Disease eGFR"),
      CohortIncidence::createCohortRef(id = 24912, name = "Crohn's Disease Creatinine EU"),
      CohortIncidence::createCohortRef(id = 24913, name = "Crohn's Disease Creatinine USA"),
      CohortIncidence::createCohortRef(id = 24914, name = "Crohn's Disease Hemoglobin EU"),
      CohortIncidence::createCohortRef(id = 24915, name = "Crohn's Disease Hemoglobin USA"),
      CohortIncidence::createCohortRef(id = 24916, name = "Crohn's Disease Leucocytes EU"),
      CohortIncidence::createCohortRef(id = 24917, name = "Crohn's Disease Leucocytes USA"),
      CohortIncidence::createCohortRef(id = 24918, name = "Crohn's Disease Platelets"),
      CohortIncidence::createCohortRef(id = 24919, name = "Ulcerative Colitis ALT"),
      CohortIncidence::createCohortRef(id = 24920, name = "Ulcerative Colitis eGFR"),
      CohortIncidence::createCohortRef(id = 24921, name = "Ulcerative Colitis Creatinine EU"),
      CohortIncidence::createCohortRef(id = 24922, name = "Ulcerative Colitis Creatinine USA"),
      CohortIncidence::createCohortRef(id = 24923, name = "Ulcerative Colitis Hemoglobin EU"),
      CohortIncidence::createCohortRef(id = 24924, name = "Ulcerative Colitis Hemoglobin USA"),
      CohortIncidence::createCohortRef(id = 24925, name = "Ulcerative Colitis Leucocytes EU"),
      CohortIncidence::createCohortRef(id = 24926, name = "Ulcerative Colitis Leucocytes USA"),
      CohortIncidence::createCohortRef(id = 24927, name = "Ulcerative Colitis Platelets"),
      CohortIncidence::createCohortRef(id = 24769, name = "Overall ALT"),
      CohortIncidence::createCohortRef(id = 24770, name = "Overall eGFR"),
      CohortIncidence::createCohortRef(id = 24840, name = "Overall Creatinine EU"),
      CohortIncidence::createCohortRef(id = 24771, name = "Overall Creatinine USA"),
      CohortIncidence::createCohortRef(id = 24841, name = "Overall Hemoglobin EU"),
      CohortIncidence::createCohortRef(id = 24772, name = "Overall Hemoglobin USA"),
      CohortIncidence::createCohortRef(id = 24842, name = "Overall Leucocytes EU"),
      CohortIncidence::createCohortRef(id = 24773, name = "Overall Leucocytes USA"),
      CohortIncidence::createCohortRef(id = 24774, name = "Overall Platelets")
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
      24843, 24844, 24845, 24846, 24847, 24848, 24849, 24850, 24851,
      24852, 24853, 24854, 24886, 24887, 24888, 24889, 24890, 24891,
      24892, 24893, 24894, 24895, 24896, 24897, 24898, 24899, 24900,
      24901, 24902, 24903, 24904, 24905, 24906, 24907, 24908, 24909,
      24910, 24911, 24912, 24913, 24914, 24915, 24916, 24917, 24918,
      24919, 24920, 24921, 24922, 24923, 24924, 24925, 24926, 24927,
      24769, 24770, 24840, 24771, 24841, 24772, 24842, 24773, 24774
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
