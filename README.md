MTXlab
=================

<img src="https://img.shields.io/badge/Study%20Status-Repo%20Created-lightgray.svg" alt="Study Status: Repo Created">

- Analytics use case(s): **Characterization**
- Study type: **Characterization**
- Tags: **Prediction models**
- Study lead: **Alexander Saelmans**
- Study lead forums tag: **[add](https://forums.ohdsi.org/u/add)**
- Study start date: **08-05-2026**
- Study end date: **-**
- Protocol: **-**
- Publications: **-**
- Results explorer: **-**

Code to run
================

```r

#Laboratory measurement characteristics

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

#Baseline characteristics

#Incidence rates

#Kaplan-Meier plots

```
