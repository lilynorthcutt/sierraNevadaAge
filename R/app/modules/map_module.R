# modules/map_module.R

# ----------- UI ----------- #
mapModuleUI <- function(id){
  ns <- NS(id)
  # ---------- MAP ----------- #
  tagList(
    leafletOutput(ns("map")),
    sliderInput(ns("age_slider"), "", min = min(df_point_csv$Age), 
                max = max(df_point_csv$Age), 
                value = min(df_point_csv$Age),
                step = 1, 
                animate = animationOptions(interval = 1000, loop = FALSE) )
  )
}

# ----------- Server Funcs ----------- #
mapModule <- function(input, output, session, border_poly, all_polygons, df_point_csv){
  ns <- session$ns
  
  output$map <- renderLeaflet({
    ### LEAFLET PLOT
    leaflet(df_point_csv) %>% 
      addTiles(group = "street-view") %>% 
      addProviderTiles(providers$CartoDB.Positron, group = "base-layer") %>%
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
      addLayersControl(baseGroups = c("base-layer", "street-view"), 
                       overlayGroups = c("border", "individual-polygons", "ages",
                                         'Grid: 0.5 degrees', 'Grid: 0.1 degrees'),
                       position = 'topright') %>% 
      hideGroup('Grid: 0.5 degrees') %>% hideGroup('Grid: 0.1 degrees')
    
  })
  


  observeEvent(input$age_slider, {
    # Filter markers to greater than or equal to age on slider
    selected_age <- input$age_slider
    filtered_points <- df_point_csv %>% filter(Age >= selected_age)

    leafletProxy("map", session) %>%
      addCircleMarkers(data = filtered_points, lat = ~ lat, lng = ~ long,
                       radius = 5,
                       color = ~ pal(Age),
                       fillColor = ~ pal(Age),
                       stroke = FALSE,
                       popup = ~ paste0("Age: ", as.character(Age), " Ma" ),
                       fillOpacity = 1,
                       group = "ages")


  })
  
  }