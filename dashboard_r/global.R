library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(DT)
library(shinyWidgets)   # opcional
library(leaflet)        # opcional si usás mapas

# Leer csv
ecommerce <- read.csv("data/sales_data.csv", stringsAsFactors = FALSE)

# Convertir texto en fechas reales
ecommerce$Date <- as.Date(ecommerce$Date)

# Eliminar nulos
ecommerce <- ecommerce %>% filter(!is.na(Revenue), !is.na(Profit))


