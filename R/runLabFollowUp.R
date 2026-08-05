runLabFollowUp <- function(
  con,
  workDatabaseSchema,
  cohortTable,
  cdmDatabaseSchema
) {

  labDefinitions <- getLabDefinitions()

  output <- list()

  for(i in seq_len(nrow(labDefinitions))) {

    output[[ labDefinitions$labName[i] ]] <-
      calculateLabFollowUp(
        con = con,
        workDatabaseSchema = workDatabaseSchema,
        cohortTable = cohortTable,
        cdmDatabaseSchema = cdmDatabaseSchema,

        labName =
          labDefinitions$labName[i],

        cohortDefinitionId =
          labDefinitions$cohortDefinitionId[i],

        ancestorConceptId =
          labDefinitions$ancestorConceptId[i],

        abnormalLowerLimit =
          labDefinitions$abnormalLowerLimit[i],

        abnormalUpperLimit =
          labDefinitions$abnormalUpperLimit[i]
      )

  }

  output

}
