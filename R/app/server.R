library(shiny)

function(input, output, session){
 # ------------ THEME ------------- #
  # observe(session$setCurrentTheme(
  #   if (isTRUE(input$dark_mode)) dark else light
  # ))
  
 # ------------ Panel --------------- # 
  observeEvent(input$age_slider, {
    # Filter markers to greater than or equal to age on slider
    selected_age <- input$age_slider
    filtered_points <- df_point_csv %>% filter(Age >= selected_age)
   
    
    ### NOTE: If/else statement to resolve clearing markers each time as this made visuals
    # choppy and ugly during the animation. Now we only clear the markers if the selected age is than
    # the previous age (i.e. we are going backwards on the slider/in the animation)
    if(prev_age < selected_age){
      leafletProxy("map") %>%
        clearMarkers() %>% 
        addCircleMarkers(data = filtered_points, lat = ~ lat, lng = ~ long,
                         radius = 5,
                         color = ~ pal(Age),
                         fillColor = ~ pal(Age),
                         stroke = FALSE,
                         popup = ~ paste0("Age: ", as.character(Age), " Ma" ),
                         fillOpacity = 1,
                         group = "ages")
    }else{
      leafletProxy("map") %>%
        addCircleMarkers(data = filtered_points, lat = ~ lat, lng = ~ long,
                         radius = 5,
                         color = ~ pal(Age),
                         fillColor = ~ pal(Age),
                         stroke = FALSE,
                         popup = ~ paste0("Age: ", as.character(Age), " Ma" ),
                         fillOpacity = 1,
                         group = "ages")
    }

    # Need <<- not <- to update global variable prev_age  
    prev_age <<- selected_age
    
    
  })  
  
  observeEvent(input$polyopacity, {

    leafletProxy("map") %>%
      clearShapes() %>%
      # Add border polygon
      addPolygons(data = border_poly,
                  color = 'black',
                  fill = FALSE,
                  dashArray = "10",
                  group = 'border') %>%
      # Fill
      addPolygons(data = all_polygons,
                  color = ~ pal(ageNum),
                  fill = ~ pal(ageNum),
                  fillOpacity = input$polyopacity,
                  weight = 2,
                  popup = ~ paste0("Period: ", Age, "\n",
                                   "Approx. Age: ", as.character(ageNum), " Ma" ),
                  group = "individualpolygons") %>% 
      # Add grid options
      addGraticule(interval = .5, group = 'Grid: 0.5 degrees') %>% 
      addGraticule(interval = .1, group = 'Grid: 0.1 degrees') 
      


  })

  
 # ------------ Map --------------- # 
  output$map <- renderLeaflet({
    ### LEAFLET PLOT
    leaflet(df_point_csv) %>% 
      addTiles(group = "street-view") %>% 
      addProviderTiles(providers$CartoDB.Positron, group = "base-layer") %>%
      addProviderTiles(providers$USGS.USImagery, group = "satelite") %>% 
      addProviderTiles(providers$Esri.WorldTerrain, group = "terrain") %>% 
      setView(lng = -119.7, lat = 37.7, zoom = 8.4) %>% 
      #Add individual polygons
      # Outline
      addPolygons(data = all_polygons,
                  color = ~ pal(ageNum),
                  fill = FALSE,
                  fillOpacity = 0.1,
                  weight = 2,
                  popup = ~ paste0("Period: ", Age, "\n",
                                   "Approx. Age: ", as.character(ageNum), " Ma" ),
                  group = "individualpolygons") %>% 
      #Add individual polygons
      # Fill
      addPolygons(data = all_polygons,
                  color = ~ pal(ageNum),
                  fill = ~ pal(ageNum),
                  fillOpacity = 0.1,
                  weight = 2,
                  popup = ~ paste0("Period: ", Age, "\n",
                                   "Approx. Age: ", as.character(ageNum), " Ma" ),
                  group = "individualpolygons") %>% 
      
      # Add legend
      addLegend(pal = pal, values = c(df_point_csv$Age, cretaceousIntrusionsIndividualPolygons$ageNum),
                position = 'bottomright', title = "Age (Ma)")%>% 
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
      addGraticule(interval = .5, group = 'Grid: 0.5 degrees', sphere = TRUE) %>% 
      addGraticule(interval = .1, group = 'Grid: 0.1 degrees') %>% 
      # Add in opportunity for making selections in the graph
      addLayersControl(baseGroups = c("base-layer", "satelite", "terrain","street-view"), 
                       overlayGroups = c("border", "individualpolygons", "ages",
                                         'Grid: 0.5 degrees', 'Grid: 0.1 degrees'),
                       position = 'topright') %>% 
      hideGroup('Grid: 0.5 degrees') %>% hideGroup('Grid: 0.1 degrees')
    
  })
  

  
}