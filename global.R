# Title: global.R for Bangladesh District Guessing Game
# Author: Siddiqur Rahman
# Date: 2024-07-04
# Description: This file handles the initial setup, loading libraries and data.
#              It runs once when the Shiny application starts.

# --- 1. Install and Load Required Packages ---
# Make sure you have these packages installed. If not, run these lines in your R console:
# install.packages(c("shiny", "leaflet", "sf", "dplyr"))

library(shiny)
library(leaflet)
library(sf)
library(dplyr) # For the pipe operator (%>%)

# --- 2. Data Acquisition and Preparation ---
# This section is modified to load a local GeoJSON file.
# For this to work, place your "BD_Districts_formatted.geojson" file in the same folder as this app.R file.
local_geojson_path <- "BD_Districts_formatted.geojson"

# Using a try-catch block to handle potential file reading errors
tryCatch({
  bgd_districts <- st_read(local_geojson_path) %>%
    st_transform(4326) # Ensure data is in WGS84 for Leaflet
    
  # Check if the required column 'shapeName' exists.
  if (!"shapeName" %in% names(bgd_districts)) {
    warning("The column 'shapeName' was not found in your GeoJSON file. The game may not work correctly.")
  }
  
}, error = function(e) {
  stop("Failed to read the GeoJSON file. Please check the path and format. Error: ", e$message)
})
