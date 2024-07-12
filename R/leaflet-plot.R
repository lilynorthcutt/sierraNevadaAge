packages <- c("tidyr", "dplyr", "magrittr", "purrr", "ggplot2", 
              "lubridate", "plyr","sp", "plotly",
              "shiny", "shinyjs", "leaflet", "geojsonsf", "sf") 
invisible(lapply(packages, require, character.only = TRUE ))

#######################
### Read in Data
#######################
# Point data
point_filepath = "Data/processed/Points/points"
df_point_csv <- read.csv(paste0(point_filepath, ".csv"))
df_point_shp <- read_sf(paste0(point_filepath, ".geojson"))


# Shapefile Data
polygon_filepath = "Data/processed/Polygons/"
polygon_files = list.files(polygon_filepath)
cretaceousIntrusionsExtentPolygons <- read_sf(paste0(polygon_filepath, "CretaceousIntrusionsExtentPolygons.geojson"))
cretaceousIntrusionsIndividualPolygons <- read_sf(paste0(polygon_filepath, "CretaceousIntrusionsIndividualPolygons.geojson"))
detailedMapDataAreaBoundaryLine <- read_sf(paste0(polygon_filepath, "DetailedMapDataAreaBoundaryLine.geojson"))
intrusiveSuitePolygons <- read_sf(paste0(polygon_filepath, "IntrusiveSuitePolygons.geojson"))


############################
# Building a leaflet graph
###########################
# Color palette
pal <- colorNumeric(
  #palette = colorRamp(c("orange", "red"), interpolate = "spline"),
  #palette = "Spectral",
  palette = "viridis",
  domain = c(df_point_csv$Age, cretaceousIntrusionsIndividualPolygons$ageNum),
  reverse = TRUE
)

# Transform border to leaflet projection
border_poly <- detailedMapDataAreaBoundaryLine %>%
  st_as_sf(coords = c("longitud", "latitude")) %>%
  st_transform(crs = '+proj=longlat +datum=WGS84')

# Transform all borders
all_polygons <- cretaceousIntrusionsIndividualPolygons %>% 
  st_as_sf(coords = c("longitud", "latitude")) %>%
  st_transform(crs = '+proj=longlat +datum=WGS84') 
  # Add popup variable
  #mutate(popup = paste0("<strong> Period", ))
  


### LEAFLET PLOT
leaflet(df_point_csv) %>% 
  addTiles(group = "street-view") %>% 
  leaflet::addProviderTiles(providers$CartoDB.Positron, group = "base-layer") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "world") %>% 
  addProviderTiles(providers$Esri.WorldTerrain, group = "terrain") %>% 
  setView(lng = -119.7, lat = 37.7, zoom = 8.4) %>% 
  #Add individual polygons
  addPolygons(data = all_polygons,
              #color = "grey",
              #fill = FALSE,
              color = ~ pal(ageNum),
              fill = ~ pal(ageNum),
              fillOpacity = .1,
              weight = 2,
              popup = ~ paste0("Period: ", Age, "\n",
                               "Approx. Age: ", as.character(ageNum), " Ma" ),
              group = "individual-polygons") %>% 
  # Add legend
  addLegend(pal = pal, values = c(df_point_csv$Age, cretaceousIntrusionsIndividualPolygons$ageNum),
            position = 'bottomright')%>% 
  # Add border polygon
  addPolygons(data = border_poly, 
              color = 'black', 
              fill = FALSE, 
              dashArray = "10",
              group = 'border') %>% 
  # Add Markers
  addCircleMarkers(df_point_csv, lat = ~ lat, lng = ~ long,
                   radius = 5, 
                   color = ~ pal(Age),
                   fillColor = ~ pal(Age),
                   stroke = FALSE,
                   popup = ~ paste0("Age: ", as.character(Age), " Ma" ),
                   fillOpacity = 1, 
                   group = "ages") %>% 
  # Add measurement option
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  # Add grid options
  addGraticule(interval = .5, group = 'Grid: 0.5 degrees') %>% 
  addGraticule(interval = .1, group = 'Grid: 0.1 degrees') %>% 
  # Add in opportunity for making selections in the graph
  addLayersControl(baseGroups = c("base-layer", "world", "terrain","street-view"), 
                   overlayGroups = c("border", "individual-polygons", "ages",
                                     'Grid: 0.5 degrees', 'Grid: 0.1 degrees'),
                   position = 'topright') %>% 
  hideGroup('Grid: 0.5 degrees') %>% hideGroup('Grid: 0.1 degrees')
  



# Map base options
# https://leaflet-extras.github.io/leaflet-providers/preview/
# https://github.com/leaflet-extras/leaflet-providers





#
