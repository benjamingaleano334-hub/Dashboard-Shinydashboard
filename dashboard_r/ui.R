ui <- dashboardPage(
  # Encabezado
  dashboardHeader(title = "E-Commerce Inventory Analytics"),
  
  # Barra lateral
  dashboardSidebar(
    sidebarMenu(
      menuItem("Panorama", tabName = "panorama", icon = icon("chart-line")),
      menuItem("Productos", tabName = "productos", icon = icon("shopping-cart")),
      menuItem("Stock", tabName = "stock", icon = icon("boxes"))
    ),
    
    # Filtros
    selectInput("year", "Año:", choices = sort(unique(ecommerce$Year)),
                selectize = TRUE) %>% 
      tagAppendAttributes(title = "Seleccioná el año de análisis"),
    selectInput("country", "País:", choices = sort(unique(ecommerce$Country))),
    selectInput("category", "Categoría:", choices = sort(unique(ecommerce$Product_Category)))
  ),
  
  # Cuerpo
  dashboardBody(
    tags$head(
      tags$style(HTML("
      /* Paleta de colores */
      body, .content-wrapper {
        background-color: #f5f7fa;
        font-family: 'Roboto', sans-serif;
      }
      .skin-blue .main-header .logo {
        background-color: #1f3c88; /* color primario */
        color: white;
        font-weight: bold;
      }
      .skin-blue .main-header .navbar {
        background-color: #1f3c88;
      }
      .skin-blue .sidebar-menu > li.active > a {
        background-color: #ff6f3c; /* color de acento */
        color: white;
      }
      /* Boxes y valueBoxes */
      .small-box {
        border-radius: 8px;
      }
    "))
    ),
    tabItems(
      tabItem(tabName = "panorama",
              h2("Panorama General del Negocio"),
              p("Este apartado ofrece una visión global del rendimiento del negocio mostrando métricas clave y la evolución de las ventas en el tiempo."),
              fluidRow(
                valueBoxOutput("total_revenue"),
                valueBoxOutput("total_profit"),
                valueBoxOutput("total_units"),
                valueBoxOutput("total_products")
              ),
              fluidRow(
                box(width = 6, plotlyOutput("ventas_mes")),
                box(width = 6, plotlyOutput("ventas_pais"))
              )
      ),
      tabItem(tabName = "productos",
              h2("Rendimiento de Productos y Categorías"),
              p("Aquí se analiza qué productos y categorías impulsan las ventas, destacando los más relevantes y su participación en el total."),
              fluidRow(
                box(width = 6, plotlyOutput("top_productos")),
                box(width = 6, plotlyOutput("profit_categoria"))
              ),
              fluidRow(
                box(width = 12, DTOutput("tabla_productos"))
              )
      ),
      tabItem(tabName = "stock",
              h2("Estacionalidad y Decisiones de Stock"),
              p("En esta sección se identifican patrones de demanda para optimizar inventario, reduciendo costos de almacenamiento y stock muerto."),
              fluidRow(
                box(width = 6, plotlyOutput("ventas_temporada")),
                box(width = 6, plotlyOutput("heatmap_producto_mes"))
              ),
              fluidRow(
                box(width = 12, textOutput("recomendacion_stock"))
              )
      )
    )
  ),
  
  # Estilo
  skin = "blue"
)

  
  