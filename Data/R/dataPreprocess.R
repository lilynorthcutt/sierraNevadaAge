packages <- c("readxl", "dplyr", "magrittr")                     
lapply(packages, require, character.only = TRUE )
source("Data/R/funcs.R")

###############################################################
### READ IN DATA ###
dataPath <- "Data/attia_CentralSierraCretaceousIntrusionsGeochronologyData_forLily12082023.xlsx"
dataSheet <- 'CentralSierraNevada Rock Ages'
rawData <- read_excel(dataPath, sheet = dataSheet, col_names = TRUE )

# Standardize colnames 
colnames(rawData) <- toCamelCase(colnames(rawData))

###############################################################
## MISSING DATA

# Add originalName to empty cells (same as analysisName)
# Add nameChange col to keep track
data <- rawData %>% mutate(
  originalName = case_when(is.na(originalName) ~analysisName, T ~originalName),
  nameChange = case_when(originalName == analysisName ~FALSE, T ~TRUE)
)

# Store data with missing location elsewhere
incompleteData <- data %>% filter(is.na(easting) | is.na(northing) |
                                    easting == "NA*" | northing == "NA*")
data %<>% filter(!is.na(easting) , !is.na(northing) ,
                   !(easting == "NA*") , !(northing == "NA*"))

# Label if the location is approximates/guessed
data %<>% mutate(
  locationEstimated = case_when(
    grepl("location not given", tolower(dataComment)) ~TRUE,
    grepl("location is a total guess",  tolower(dataComment)) ~TRUE,
    grepl("approximate location",  tolower(dataComment)) ~TRUE,
    T ~FALSE
  )
)

# Label if uncertainty is estimated
data %<>% mutate(
  uncertaintyEstimated = case_when(
    grepl("no error given", tolower(dataComment)) ~TRUE,
    T ~FALSE
  )
)

# Add year published (NOTE: if no date - 2023)
data %<>% mutate(
  year = gsub(".*?([0-9]+).*", "\\1", reference) %>% as.numeric(),
  year = case_when(is.na(year) ~2023, T ~year)
  ) 

# Correct data types for age, easting, and northing
data %<>% mutate(
  age = as.numeric(age),
  easting = as.numeric(easting),
  northing = as.numeric(northing)
) 


# Add Quadrants
data %<>% mutate(
  eastGroup = case_when(easting <= 250000 ~1,
                        (easting > 250000 & easting <= 300000) ~2,
                        (easting > 300000 & easting <= 350000) ~3,
                        T ~4),
  northGroup = case_when(northing <= 4150000 ~1,
                         (northing > 4150000 & northing <= 4200000) ~2,
                         (northing > 4200000 & northing <= 4250000) ~3,
                         T ~4),
  
)







#
