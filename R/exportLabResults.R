exportLabResults <- function(
    results,
    outputFile
) {

  wb <- openxlsx::createWorkbook()

  for (labName in names(results)) {

    openxlsx::addWorksheet(
      wb,
      labName
    )

    openxlsx::writeData(
      wb,
      sheet = labName,
      x = results[[labName]]
    )

  }

  openxlsx::saveWorkbook(
    wb,
    file = outputFile,
    overwrite = TRUE
  )

}
