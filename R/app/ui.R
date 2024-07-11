# < ------------- SHINY UI ------------- >

fluidPage(
  useShinyjs(), # Include shinyjs
  titlePanel("Geologic Age Visualization"),
  sidebarLayout(
    # -----------Sidebar -------------- #
    sidebarPanel(
      pickerInput("model", "Predict unknown ages:",
                  choices = model_names,
                  selected = NULL,
                  multiple = TRUE,
                  options = pickerOptions(maxOptions = 1))
      ),
    # -----------Main Panel -------------- #
    mainPanel(
      leafletOutput("map"),
      sliderTextInput("age_slider", "", #min = min(df_point_csv$Age), max = max(df_point_csv$Age),
                 choices = age_slider_scale,
                 selected = max(df_point_csv$Age),
                 #step = 1, 
                 animate = animationOptions(interval = 250, loop = FALSE) )
      )
    )
)