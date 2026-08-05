runLabFollowUp <- function(
    con,
    workDatabaseSchema,
    cohortTable,
    cdmDatabaseSchema
) {

  labs <- getLabDefinitions()

  results <- list()

  for (i in seq_len(nrow(labs))) {

    message(
      "Running ",
      labs$labName[i]
    )

    results[[labs$labName[i]]] <-
      calculateLabFollowUp(
        con = con,
        workDatabaseSchema = workDatabaseSchema,
        cohortTable = cohortTable,
        cdmDatabaseSchema = cdmDatabaseSchema,

        labName =
          labs$labName[i],

        cohortDefinitionId =
          labs$cohortDefinitionId[i],

        ancestorConceptId =
          labs$ancestorConceptId[i],

        abnormalLowerLimit =
          labs$abnormalLowerLimit[i],

        abnormalUpperLimit =
          labs$abnormalUpperLimit[i]
      )

  }

  return(results)

}
