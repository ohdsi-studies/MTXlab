#' @export
generateCohorts <- function(
    connectionDetails,
    cdmDatabaseSchema,
    cohortDatabaseSchema,
    cohortTable,
    tempDatabaseSchema
){
  
  cohortDefinitionSet <- readRDS(system.file('cohortDefinitionSet.rds', package = 'MTXlab'))
  
  cohortTableNames <- CohortGenerator::getCohortTableNames(
    cohortTable = cohortTable
  )
  
  CohortGenerator::createCohortTables(
    connectionDetails = connectionDetails,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTableNames = cohortTableNames
  )
  
  CohortGenerator::generateCohortSet(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    tempEmulationSchema = cohortDatabaseSchema,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortTableNames = cohortTableNames,
    cohortDefinitionSet = cohortDefinitionSet
  )

  }
