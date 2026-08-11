MTXlab
=================

<img src="https://img.shields.io/badge/Study%20Status-Repo%20Created-lightgray.svg" alt="Study Status: Repo Created">

- Analytics use case(s): **Characterization**
- Study type: **Characterization**
- Tags: **Characterization & Prediction models**
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
#Inputs

connectionDetails <- ""
workDatabaseSchema <- ""
cohortTable <- ""
cdmDatabaseSchema <- ""
outputFolder <- "" #path to the folder that should contain the output
sourceName <- "" #name of the database/source

#Generate cohorts

generateCohorts <- function(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDatabaseSchema = workDatabaseSchema,
    cohortTable = cohortTable,
    tempDatabaseSchema
)

# PART I

#Laboratory measurement characteristics

results <- runLabFollowUp(
  con = connectionDetails,
  workDatabaseSchema = workDatabaseSchema,
  cohortTable = cohortTable,
  cdmDatabaseSchema = cdmDatabaseSchema
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

results <- runIncidenceAnalysis(
connectionDetails = connectionDetails,
cdmDatabaseSchema = cdmDatabaseSchema,
cohortDatabaseSchema = workDatabaseSchema,
cohortTable = cohortTable,
workDatabaseSchema = workDatabaseSchema,
sourceName = sourceName,
outputFolder = outputFolder
)

#Kaplan-Meier plots




# PART II

#Model development


#Model validation


```

Submitting results
================

The results can be submitted as follows


```r


```
