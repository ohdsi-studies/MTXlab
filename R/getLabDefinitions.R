#' Returns a dataframe with lab definitions
#'
#' @details
#' The user specifies 
#'
#' @return
#' a data frame
#' 
#' @export
getLabDefinitions <- function() {

  data.frame(
    labName = c(
      "ALT",
      "eGFR",
      "Creatinine EU",
      "Creatinine USA",
      "Hemoglobin EU",
      "Hemoglobin USA",
      "Leucocytes EU",
      "Leucocytes USA",
      "Platelets"
    ),

    cohortDefinitionId = c(
      24769,
      24770,
      24840,
      24771,
      24841,
      24772,
      24842,
      24773,
      24774
    ),

    ancestorConceptId = c(
      4146380,
      36662614,
      3016723,
      3016723,
      3000963,
      3000963,
      37043992,
      37043992,
      4267147
    ),

    abnormalLowerLimit = c(
      150,
      10,
      125,
      1.28,
      2,
      3.22,
      0.5,
      500,
      10
    ),

    abnormalUpperLimit = c(
      1000,
      45,
      500,
      5.65,
      6,
      9.67,
      2,
      2000,
      100
    )
  )

}
