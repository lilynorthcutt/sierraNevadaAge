packages <- c("tidyr", "dplyr", "magrittr", "purrr", "ggplot2", "readxl",
               "lubridate", "plyr","sp",
              "shiny", "shinyjs", "shinyWidgets","bslib",
              "leaflet", "geojsonsf", "sf") 
library(tidyr)
library(dplyr)
library(magrittr)
library(purrr)
library(ggplot2)
library(readxl)
library(lubridate)
library(plyr)
library(sp)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(bslib)
library(leaflet)
library(geojsonsf)
library(sf)
#invisible(lapply(packages, require, character.only = TRUE ))

# ------------- Read in Data ------------- #
# Point data
point_filepath = "Data/processed/Points/points"
df_point_csv <- read.csv(paste0(point_filepath, ".csv"))
df_point_shp <- read_sf(paste0(point_filepath, ".geojson"))


# Shapefile Data
polygon_filepath = "Data/processed/Polygons/"
polygon_files = list.files(polygon_filepath)
cretaceousIntrusionsIndividualPolygons <- read_sf(paste0(polygon_filepath, "UnionPolygons.geojson")) %>% 
  mutate(
    Age = gsub("[[:punct:]]", " ", Age),
    ageNum = case_when(
      Age == "KJ" ~145,
      Age == "eK" ~125,
      T ~85
    )
  )
detailedMapDataAreaBoundaryLine <- read_sf(paste0(polygon_filepath, "DetailedMapDataAreaBoundaryLine.geojson"))


# Predicted data
model_filepath = 'Data/output/model_output.xlsx'
model_preds <- read_excel(model_filepath, sheet = 'model-predictions')
model_stats <- read_excel(model_filepath, sheet = 'model-statistics')
model_names <- model_preds %>% select(-lat, -lng) %>% colnames()

# ------------- Convert to Leaflet Projection ------------- #
# Transform
border_poly <- detailedMapDataAreaBoundaryLine %>%
  st_as_sf(coords = c("longitud", "latitude")) %>%
  st_transform(crs = '+proj=longlat +datum=WGS84')

# Transform all borders
all_polygons <- cretaceousIntrusionsIndividualPolygons %>%
  st_as_sf(coords = c("longitud", "latitude")) %>%
  st_transform(crs = '+proj=longlat +datum=WGS84')


# ------------- Set Color Palette ------------- #
pal <- colorNumeric(
  #palette = colorRamp(c("orange", "red"), interpolate = "spline"),
  #palette = "Spectral",
  palette = "viridis",
  domain = c(df_point_csv$Age, cretaceousIntrusionsIndividualPolygons$ageNum),
  reverse = TRUE
)

# ------------- Set Age Scale ------------- #
#age_slider_scale <- df_point_csv[["Age"]] %>% unique() %>% sort(decreasing = T)
age_slider_scale <- seq(from = max(df_point_csv$Age)+1, to = min(df_point_csv$Age)-1, -1)
prev_age <- max(df_point_csv$Age)+1

# ------------- Source modules ------------- #
#source("modules/map_module.R")


# ----------------------------------------------------------------------
# To deploy: rsconnect::deployApp('R/app', appName = "geoAges")