# < ------------- SHINY UI ------------- >
#light <- bs_theme()
#dark <- bs_theme(bg = "black", fg = "white", primary = "purple")

page_sidebar(
  title = "Geologic Age Visualization",
  
  # ----------Sidebar------------- #
  sidebar = sidebar(
    accordion(
      #------------ Accordion: Graph Options ----------------#
      accordion_panel(
        "Graph Options",
        sliderInput("polyopacity", "Individual Polygon Opacity:", min = 0, max = 1,
                    value = 0.1, step = 0.01)
      ),
      #------------ Accordion: Model Options ----------------#
      accordion_panel(
        "Model Options",
        pickerInput("model", "Predict unknown ages:",
                    choices = model_names,
                    selected = NULL,
                    multiple = TRUE,
                    options = pickerOptions(maxOptions = 1))
      )
    )
  ), #### End sidebar
  leafletOutput("map"),
  sliderTextInput("age_slider", "Age (Ma):", 
                  choices = age_slider_scale,
                  selected = prev_age,
                  #step = 1, 
                  animate = animationOptions(interval = 250, loop = FALSE) )
  
)


