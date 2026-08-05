MTXlab
=================


Code to run
================

```r
### Laboratory measurement characteristics

results <- runLabFollowUp(
  con = con,
  workDatabaseSchema = "",
  cohortTable = "",
  cdmDatabaseSchema = ""
)

exportLabResults(
  results,
  file.path(
    outputFolder,
    "MTX_Lab_Followup.xlsx"
  )
)

### Baseline characteristics

### Incidence rates

### Kaplan-Meier plots

```
