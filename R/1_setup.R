library(magrittr)
library(shiny)
library(shinyWidgets) # probably
library(dplyr)
library(leaflet)
library(sf)
library(bslib) # probably
library(htmltools) # for now
library(scales)
library(DT)
library(reactable)

#load(data files to load)

load ("./data/gb_area.rda")

cons <- read_sf("./data/gb_cons.gpkg")

# API stuff for OS basemap
Sys.setenv(OS_PROJECT_API_KEY = '2k5mBPfuwVyU9MO8WOfbtCuYB0gRVtF3')

OSLight_3857 <- paste0("https://api.os.uk/maps/raster/v1/zxy/Light_3857/{z}/{x}/{y}.png?key=",Sys.getenv("OS_PROJECT_API_KEY"))

### for deeplinking
shiny::enableBookmarking(store = "url")