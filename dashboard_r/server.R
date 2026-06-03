server <- function(input, output, session) {
  # 🔹 1. Dataset filtrado según los inputs del sidebar
  datos_filtrados <- reactive({
    ecommerce %>%
      filter(
        Year == input$year,
        Country == input$country,
        Product_Category == input$category
      )
  })
  
  # 🔹 2. KPIs (valueBox)
  output$total_revenue <- renderValueBox({
    valueBox(
      format(sum(datos_filtrados()$Unit_Price * datos_filtrados()$Order_Quantity), big.mark = "."),
      "Revenue Total",
      icon = icon("dollar-sign"),
      color = "green"
    )
  })
  
  output$total_profit <- renderValueBox({
    valueBox(
      format(sum((datos_filtrados()$Unit_Price - datos_filtrados()$Unit_Cost) * datos_filtrados()$Order_Quantity), big.mark = "."),
      "Profit Total",
      icon = icon("chart-line"),
      color = "blue"
    )
  })
  
  output$total_units <- renderValueBox({
    valueBox(
      sum(datos_filtrados()$Order_Quantity),
      "Unidades Vendidas",
      icon = icon("boxes"),
      color = "purple"
    )
  })
  
  output$total_products <- renderValueBox({
    valueBox(
      n_distinct(datos_filtrados()$Product),
      "Productos Distintos",
      icon = icon("tags"),
      color = "orange"
    )
  })
  
  # Gráfico de evolución de ventas por mes
  output$ventas_mes <- renderPlotly({
    
    # Definir equivalencias de meses en inglés → español
    meses_en <- c("January","February","March","April","May","June",
                  "July","August","September","October","November","December")
    meses_es <- c("Enero","Febrero","Marzo","Abril","Mayo","Junio",
                  "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre")
    
    # Dataframe base con los 12 meses
    meses_base <- data.frame(
      Month = meses_en,
      MesNombre = factor(meses_es, levels = meses_es)
    )
    
    # Calcular revenue por mes
    datos <- datos_filtrados() %>%
      group_by(Month) %>%
      summarise(Revenue = sum(Unit_Price * Order_Quantity))
    
    # Unir con los 12 meses y reemplazar NA por 0
    datos_completos <- left_join(meses_base, datos, by = "Month") %>%
      mutate(Revenue = replace_na(Revenue, 0))
    
    # Graficar
    plot_ly(datos_completos, x = ~MesNombre, y = ~Revenue,
            type = "scatter", mode = "lines+markers") %>%
      layout(title = "Evolución de Ventas por Mes",
             xaxis = list(title = "Mes"),
             yaxis = list(title = "Ingresos"))
  })
  
  output$ventas_pais <- renderPlotly({
    datos_filtrados() %>%
      group_by(Country) %>%
      summarise(Revenue = sum(Unit_Price * Order_Quantity)) %>%
      plot_ly(x = ~Revenue, y = ~Country, type = "bar", orientation = "h") %>%
      layout(title = "Ventas por País")
  })
  
  # 🔹 4. Gráficos Productos
  output$top_productos <- renderPlotly({
    datos_filtrados() %>%
      group_by(Product) %>%
      summarise(Revenue = sum(Unit_Price * Order_Quantity)) %>%
      arrange(desc(Revenue)) %>%
      head(10) %>%
      plot_ly(x = ~Revenue, y = ~Product, type = "bar", orientation = "h") %>%
      layout(title = "Top 10 Productos por Revenue")
  })
  
  output$profit_categoria <- renderPlotly({
    datos_filtrados() %>%
      group_by(Product_Category) %>%
      summarise(Profit = sum((Unit_Price - Unit_Cost) * Order_Quantity)) %>%
      plot_ly(x = ~Product_Category, y = ~Profit, type = "bar") %>%
      layout(title = "Profit por Categoría")
  })
  
  
  # Tabla dinamica
  output$tabla_productos <- renderDT({
    datos_filtrados() %>%
      group_by(Product) %>%
      summarise(
        Revenue = sum(Unit_Price * Order_Quantity),
        Profit = sum((Unit_Price - Unit_Cost) * Order_Quantity),
        Quantity = sum(Order_Quantity)
      ) %>%
      datatable(
        extensions = c('Buttons'),   # habilita botones extra
        options = list(
          pageLength = 10,           # cantidad de filas por página
          autoWidth = TRUE,
          dom = 'Bfrtip',            # define la barra de controles
          buttons = c('csv', 'excel'), # agrega botones de descarga
          filter = 'top'             # filtros por columna arriba de la tabla
        )
      )
  })
  
  
  # Grafico stock
  output$ventas_temporada <- renderPlotly({
    
    
    meses_en <- c("January","February","March","April","May","June",
                  "July","August","September","October","November","December")
    meses_es <- c("Enero","Febrero","Marzo","Abril","Mayo","Junio",
                  "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre")
    
    meses_base <- data.frame(
      Month = meses_en,
      MesNombre = factor(meses_es, levels = meses_es)
    )
    
    datos <- datos_filtrados() %>%
      group_by(Month) %>%
      summarise(Quantity = sum(Order_Quantity))
    
    datos_completos <- left_join(meses_base, datos, by = "Month") %>%
      mutate(Quantity = replace_na(Quantity, 0))
    
    plot_ly(datos_completos, x = ~MesNombre, y = ~Quantity, type = "bar") %>%
      layout(title = "Ventas por Temporada",
             xaxis = list(title = "Mes"),
             yaxis = list(title = "Unidades"))
  })
  
  
  output$heatmap_producto_mes <- renderPlotly({
    
    
    meses_en <- c("January","February","March","April","May","June",
                  "July","August","September","October","November","December")
    meses_es <- c("Enero","Febrero","Marzo","Abril","Mayo","Junio",
                  "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre")
    
    meses_base <- data.frame(
      Month = meses_en,
      MesNombre = factor(meses_es, levels = meses_es)
    )
    
    datos <- datos_filtrados() %>%
      group_by(Product, Month) %>%
      summarise(Revenue = sum(Unit_Price * Order_Quantity))
    
    datos_completos <- left_join(meses_base, datos, by = "Month") %>%
      mutate(Revenue = replace_na(Revenue, 0))
    
    plot_ly(datos_completos, x = ~MesNombre, y = ~Product, z = ~Revenue,
            type = "heatmap", colors = "Blues") %>%
      layout(title = "Heatmap Producto × Mes",
             xaxis = list(title = "Mes"),
             yaxis = list(title = "Producto"))
  })
  
  # 🔹 7. Texto dinámico (recomendación)
  output$recomendacion_stock <- renderText({
    "Se recomienda aumentar stock de productos con alta demanda estacional y reducir inventario de productos con baja rotación para disminuir costos."
  })
}





