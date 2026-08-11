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
# Set working directory to Renv file
#==========================================#
# Download the Renv lock file from the GitHub page

# Set working directory to the Renv lock file
setwd()
# Check whether the working directory was adjusted
.libPaths()

# Activate Renv
renv::activate()
# Restore R lock file
renv::restore()
# Restart R session
.rs.restartR()

# Usethis explanation
# The inputs have been filled in using the usethis package. This allows one to use
# inputs filled in the .Renviron file.
# More information on the usethis package can be found here:
# https://usethis.r-lib.org/reference/use_description.html
# You can also add you github token to the .Renviron file with
# GITHUB-PAT=your_token_here and retrieve it with Sys.getenv("GITHUB_PAT")

library(usethis)

# Inputs to run (edit these for your CDM):
# ========================================= #
# If your database requires temp tables being created in a specific schema
if (!Sys.getenv("DATABASE_TEMP_SCHEMA") == "") {
  options(sqlRenderTempEmulationSchema = Sys.getenv("DATABASE_TEMP_SCHEMA"))
}

# Fill in your connection details and path to driver
# See ?DatabaseConnector::createConnectionDetails for help for your 
# database platform
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = Sys.getenv("DBMS"), 
  server = Sys.getenv("DATABASE_SERVER"), 
  user = Sys.getenv("DATABASE_USER"),
  password = Sys.getenv("DATABASE_PASSWORD"),
  port = Sys.getenv("DATABASE_PORT"),
  connectionString = Sys.getenv("DATABASE_CONNECTION_STRING"),
  pathToDriver = Sys.getenv("DATABASE_DRIVER")
) 

# A schema with write access to store cohort tables
workDatabaseSchema <- Sys.getenv("WORK_SCHEMA")
  
# Name of cohort table that will be created for study
cohortTable <- Sys.getenv("COHORT_TABLE")

# Schema where the cdm data is
cdmDatabaseSchema <- Sys.getenv("CDM_SCHEMA")

# Name of the database/source
sourceName <- "" #name of the database/source

# Path to the folder that should contain the output
outputFolder <- "./output/folder/" 

# =========== END OF INPUTS ========== #

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


#======================================#
# Don't forget to deactivate your Renv
renv::deactivate()

```

Submitting results
================

To send the compressed folder results please message Alexander Saelmans (a.saelmans@erasmusmc.nl) and he will give you the privateKeyFileName and userName. You can then run the following R code to share the results:

```r
# Please upload both the strategusWork and strategusOutput folders
 
# One time R package install
install_github("ohdsi/OhdsiSharing")
 
# Upload local files 'strategusWork.zip' and 'strategusOutput.zip to the sftp server study folder
library("OhdsiSharing")
 
privateKeyFileName <- "message us for this"
userName <- "message us for this"
remoteFolder <- "/"
fileName <- "example/strategusWork.zip"
sftpUploadFile(privateKeyFileName, userName, remoteFolder, fileName)

# Please send us the names given to the zip files in the sftp rcriv study folder, so we can access them


```
