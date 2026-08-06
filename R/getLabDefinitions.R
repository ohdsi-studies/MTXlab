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
    ),

    plausibleLowerLimit = c(
      1, #ALT
      1, #eGFR
      8.84, #Creatinine EU
      0.1, #Creatinine USA
      1.86, #Hemoglobin EU
      3, #Hemoglobin USA
      0, #Leucocytes EU
      0, #Leucocytes USA
      0 #Platelets
  ),

    plausibleUpperLimit = c(
      10000, #ALT
      200, #eGFR
      2653, #Creatinine EU
      30, #Creatinine USA
      12.4, #Hemoglobin EU
      20, #Hemoglobin USA
      500, #Leucocytes EU
      500000, #Leucocytes USA
      2000  #Platelets
      )

}
