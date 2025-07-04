# Title: server.R for Bangladesh District Guessing Game
# Author: Siddiqur Rahman
# Date: 2024-07-04
# Description: This file contains the server logic for the Shiny application.

# --- 4. Define the Server Logic ---
server <- function(input, output, session) {
  
  # Reactive values to store the game state
  target_district <- reactiveVal()
  game_feedback_text <- reactiveVal("Click on the map to start!")

  # Function to get a new random district
  get_new_district <- function() {
    sample(bgd_districts$shapeName, 1)
  }
  
  # Set the first district when the app starts
  observeEvent(once = TRUE, eventExpr = bgd_districts, {
      target_district(get_new_district())
  })
  
  # Handle the "Next District" button click
  observeEvent(input$next_district_btn, {
    target_district(get_new_district())
    game_feedback_text("New challenge! Find the district.")
    # Clear previous highlights
    leafletProxy("map") %>% clearGroup("selection")
  })

  # Render the initial Leaflet map
  output$map <- renderLeaflet({
    leaflet(data = bgd_districts) %>%
      # Changed to a provider without labels for a cleaner look
      addProviderTiles(providers$CartoDB.PositronNoLabels, options = providerTileOptions(noWrap = TRUE)) %>%
      addPolygons(
        fillColor = "#5DADE2",
        weight = 1,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 3,
          color = "#E74C3C",
          dashArray = "",
          fillOpacity = 0.8,
          bringToFront = TRUE
        ),
        # NO label on hover to keep it a guessing game
        layerId = ~shapeName # Use district name as ID
      ) %>%
      setView(lng = 90.3563, lat = 23.6850, zoom = 7)
  })

  # Observe map click events for guessing
  observeEvent(input$map_shape_click, {
    clicked_id <- input$map_shape_click$id
    target_id <- target_district()
    
    proxy <- leafletProxy("map", data = bgd_districts) %>%
      clearGroup("selection")
      
    if (clicked_id == target_id) {
      # CORRECT GUESS
      game_feedback_text(paste("Correct! You found", clicked_id, "!"))
      selected_polygon <- subset(bgd_districts, shapeName == clicked_id)
      proxy %>% addPolygons(
        data = selected_polygon,
        group = "selection",
        fillColor = "#28a745", # Green for correct
        weight = 3,
        color = "#155724"
      )
    } else {
      # INCORRECT GUESS
      game_feedback_text(paste("Not quite. You clicked on", clicked_id, "."))
      selected_polygon <- subset(bgd_districts, shapeName == clicked_id)
      proxy %>% addPolygons(
        data = selected_polygon,
        group = "selection",
        fillColor = "#dc3545", # Red for incorrect
        weight = 3,
        color = "#721c24"
      )
    }
  })
  
  # Render the name of the district to find
  output$target_district_name <- renderText({
    target_district()
  })
  
  # Render the game feedback
  output$game_feedback <- renderText({
    game_feedback_text()
  })
}
