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
      "ALT overall",
      "eGFR overall",
      "Creatinine EU overall",
      "Creatinine USA overall",
      "Hemoglobin EU overall",
      "Hemoglobin USA overall",
      "Leucocytes EU overall",
      "Leucocytes USA overall",
      "Platelets overall",
      "ALT AD",
      "eGFR AD",
      "Creatinine EU AD",
      "Creatinine USA AD",
      "Hemoglobin EU AD",
      "Hemoglobin USA AD",
      "Leucocytes EU AD",
      "Leucocytes USA AD",
      "Platelets AD",
      "ALT Psoriasis",
      "eGFR Psoriasis",
      "Creatinine EU Psoriasis",
      "Creatinine USA Psoriasis",
      "Hemoglobin EU Psoriasis",
      "Hemoglobin USA Psoriasis",
      "Leucocytes EU Psoriasis",
      "Leucocytes USA Psoriasis",
      "Platelets Psoriasis",
      "ALT RA",
      "eGFR RA",
      "Creatinine EU RA",
      "Creatinine USA RA",
      "Hemoglobin EU RA",
      "Hemoglobin USA RA",
      "Leucocytes EU RA",
      "Leucocytes USA RA",
      "Platelets RA",
      "ALT PsA",
      "eGFR oPsA",
      "Creatinine EU PsA",
      "Creatinine USA PsA",
      "Hemoglobin EU PsA",
      "Hemoglobin USA PsA",
      "Leucocytes EU PsA",
      "Leucocytes USA PsA",
      "Platelets PsA",
      "ALT Crohn",
      "eGFR Crohn",
      "Creatinine EU Crohn",
      "Creatinine USA Crohn",
      "Hemoglobin EU Crohn",
      "Hemoglobin USA Crohn",
      "Leucocytes EU Crohn",
      "Leucocytes USA Crohn",
      "Platelets Crohn",
      "ALT UC",
      "eGFR UC",
      "Creatinine EU UC",
      "Creatinine USA UC",
      "Hemoglobin EU UC",
      "Hemoglobin USA UC",
      "Leucocytes EU UC",
      "Leucocytes USA UC",
      "Platelets UC",
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
      24774,
      24843,
      
      
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
      4267147,
       4146380,
      36662614,
      3016723,
      3016723,
      3000963,
      3000963,
      37043992,
      37043992,
      4267147,
       4146380,
      36662614,
      3016723,
      3016723,
      3000963,
      3000963,
      37043992,
      37043992,
      4267147,
       4146380,
      36662614,
      3016723,
      3016723,
      3000963,
      3000963,
      37043992,
      37043992,
      4267147,
       4146380,
      36662614,
      3016723,
      3016723,
      3000963,
      3000963,
      37043992,
      37043992,
      4267147,
       4146380,
      36662614,
      3016723,
      3016723,
      3000963,
      3000963,
      37043992,
      37043992,
      4267147,
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
      10,
        150,
      10,
      125,
      1.28,
      2,
      3.22,
      0.5,
      500,
      10,
        150,
      10,
      125,
      1.28,
      2,
      3.22,
      0.5,
      500,
      10,
        150,
      10,
      125,
      1.28,
      2,
      3.22,
      0.5,
      500,
      10,
        150,
      10,
      125,
      1.28,
      2,
      3.22,
      0.5,
      500,
      10,
        150,
      10,
      125,
      1.28,
      2,
      3.22,
      0.5,
      500,
      10,
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
      100,
       1000,
      45,
      500,
      5.65,
      6,
      9.67,
      2,
      2000,
      100,
       1000,
      45,
      500,
      5.65,
      6,
      9.67,
      2,
      2000,
      100,
       1000,
      45,
      500,
      5.65,
      6,
      9.67,
      2,
      2000,
      100,
       1000,
      45,
      500,
      5.65,
      6,
      9.67,
      2,
      2000,
      100,
       1000,
      45,
      500,
      5.65,
      6,
      9.67,
      2,
      2000,
      100,
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
      0, #Platelets
      1, #ALT
      1, #eGFR
      8.84, #Creatinine EU
      0.1, #Creatinine USA
      1.86, #Hemoglobin EU
      3, #Hemoglobin USA
      0, #Leucocytes EU
      0, #Leucocytes USA
      0, #Platelets
      1, #ALT
      1, #eGFR
      8.84, #Creatinine EU
      0.1, #Creatinine USA
      1.86, #Hemoglobin EU
      3, #Hemoglobin USA
      0, #Leucocytes EU
      0, #Leucocytes USA
      0, #Platelets
      1, #ALT
      1, #eGFR
      8.84, #Creatinine EU
      0.1, #Creatinine USA
      1.86, #Hemoglobin EU
      3, #Hemoglobin USA
      0, #Leucocytes EU
      0, #Leucocytes USA
      0, #Platelets
      1, #ALT
      1, #eGFR
      8.84, #Creatinine EU
      0.1, #Creatinine USA
      1.86, #Hemoglobin EU
      3, #Hemoglobin USA
      0, #Leucocytes EU
      0, #Leucocytes USA
      0, #Platelets
      1, #ALT
      1, #eGFR
      8.84, #Creatinine EU
      0.1, #Creatinine USA
      1.86, #Hemoglobin EU
      3, #Hemoglobin USA
      0, #Leucocytes EU
      0, #Leucocytes USA
      0, #Platelets
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
      2000,  #Platelets
      10000, #ALT
      200, #eGFR
      2653, #Creatinine EU
      30, #Creatinine USA
      12.4, #Hemoglobin EU
      20, #Hemoglobin USA
      500, #Leucocytes EU
      500000, #Leucocytes USA
      2000,  #Platelets
      10000, #ALT
      200, #eGFR
      2653, #Creatinine EU
      30, #Creatinine USA
      12.4, #Hemoglobin EU
      20, #Hemoglobin USA
      500, #Leucocytes EU
      500000, #Leucocytes USA
      2000,  #Platelets
      10000, #ALT
      200, #eGFR
      2653, #Creatinine EU
      30, #Creatinine USA
      12.4, #Hemoglobin EU
      20, #Hemoglobin USA
      500, #Leucocytes EU
      500000, #Leucocytes USA
      2000,  #Platelets
      10000, #ALT
      200, #eGFR
      2653, #Creatinine EU
      30, #Creatinine USA
      12.4, #Hemoglobin EU
      20, #Hemoglobin USA
      500, #Leucocytes EU
      500000, #Leucocytes USA
      2000,  #Platelets
      10000, #ALT
      200, #eGFR
      2653, #Creatinine EU
      30, #Creatinine USA
      12.4, #Hemoglobin EU
      20, #Hemoglobin USA
      500, #Leucocytes EU
      500000, #Leucocytes USA
      2000,  #Platelets
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
