# Title: ui.R for Bangladesh District Guessing Game
# Author: Siddiqur Rahman
# Date: 2024-07-04
# Description: This file defines the user interface (UI) for the Shiny application.

# --- 3. Define the User Interface (UI) ---
ui <- fluidPage(
  # Application title
  titlePanel("Bangladesh District Guessing Quiz"),
  
  # Add some custom styling for better appearance
  tags$head(
    # Link to Font Awesome CSS for icons
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"),
    tags$style(HTML("
      body { background-color: #f4f6f9; }
      .title-panel { color: #333; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; }
      .leaflet-container { border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
      #game-feedback {
        margin-top: 15px;
        padding: 15px;
        background-color: #e9ecef;
        border: 1px solid #ced4da;
        border-radius: 8px;
        font-size: 1.1em;
        font-weight: bold;
        text-align: center;
      }
      .contact-info a {
        margin-left: 15px;
        color: #555;
      }
    "))
  ),
  
  # Main layout
  sidebarLayout(
    sidebarPanel(
      h3("Quiz Instructions"),
      p("1. The name of a district to find will be shown below."),
      p("2. Click on the map where you think that district is located."),
      p("3. The app will tell you if you are correct!"),
      p("4. Click the 'Next District' button to get a new challenge."),
      hr(),
      h4("Find this District:"),
      verbatimTextOutput("target_district_name"),
      hr(),
      actionButton("next_district_btn", "Next District", class = "btn-primary btn-lg btn-block"),
      hr(),
      h4("Result:"),
      verbatimTextOutput("game_feedback", placeholder = TRUE)
    ),
    
    mainPanel(
      # The main map output - Height increased to 97vh
      leafletOutput("map", height = "97vh")
    )
  ),
  
  # Contact Information Section
  hr(),
  fluidRow(
    class = "contact-info",
    style = "text-align: right; padding-right: 20px; padding-bottom: 10px;",
    tags$a(
      href = "https://www.linkedin.com/in/msrahman21",
      target = "_blank", # Opens in a new tab
      tags$i(class = "fab fa-linkedin", style = "font-size: 1.2em;"),
      "LinkedIn"
    ),
    tags$a(
      href = "https://github.com/siddik95",
      target = "_blank",
      tags$i(class = "fab fa-github", style = "font-size: 1.2em;"),
      "GitHub"
    ),
    tags$a(
      href = "https://siddik95.github.io/",
      target = "_blank",
      tags$i(class = "fas fa-globe", style = "font-size: 1.2em;"),
      "Personal Webpage"
    )
  )
)
