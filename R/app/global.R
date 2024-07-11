packages <- c("tidyr", "dplyr", "magrittr", "purrr", "ggplot2", "readxl",
               "lubridate", "plyr","sp",
              "shiny", "shinyjs", "shinyWidgets",
              "leaflet", "geojsonsf", "sf") 
invisible(lapply(packages, require, character.only = TRUE ))

# ------------- Read in Data ------------- #
# Point data
point_filepath = "../../Data/processed/Points/points"
df_point_csv <- read.csv(paste0(point_filepath, ".csv"))
df_point_shp <- read_sf(paste0(point_filepath, ".geojson"))


# Shapefile Data
polygon_filepath = "../../Data/processed/Polygons/"
polygon_files = list.files(polygon_filepath)
cretaceousIntrusionsExtentPolygons <- read_sf(paste0(polygon_filepath, "CretaceousIntrusionsExtentPolygons.geojson"))
cretaceousIntrusionsIndividualPolygons <- read_sf(paste0(polygon_filepath, "CretaceousIntrusionsIndividualPolygons.geojson"))
detailedMapDataAreaBoundaryLine <- read_sf(paste0(polygon_filepath, "DetailedMapDataAreaBoundaryLine.geojson"))
intrusiveSuitePolygons <- read_sf(paste0(polygon_filepath, "IntrusiveSuitePolygons.geojson"))


# Predicted data
model_filepath = '../../Data/output/model_output.xlsx'
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
age_slider_scale <- seq(from = max(df_point_csv$Age), to = min(df_point_csv$Age)-1, -1)


# ------------- Source modules ------------- #
#source("modules/map_module.R")