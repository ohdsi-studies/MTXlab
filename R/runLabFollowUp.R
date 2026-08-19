#' Calculate Lab Follow Up for all the iterations
#'
#' @details
#' The user specifies 
#'
#' @param con the connection by means of connectionDetails
#' @param workDatabaseSchema
#' @param cohortTable the cohort table name
#' @param cdmDatabaseSchema 
#'
#' @return
#' a data frame
#' 
#' @export
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
          labs$abnormalUpperLimit[i],

        plausibleLowerLimit =
          labs$plausibleLowerLimit[i],

        plausibleUpperLimit =
          labs$plausibleUpperLimit[i]

        
      )

  }

  return(results)

}
