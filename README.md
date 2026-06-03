
---

```markdown
# 📊 Dashboard de Ventas e Inventario – R Shiny

Dashboard interactivo desarrollado en **R Shiny** para analizar ventas e inventario de un negocio de e-commerce.

## 🎯 Objetivo
Explorar métricas clave (ingresos, beneficios, unidades vendidas, diversidad de productos) y visualizar patrones de demanda y estacionalidad para apoyar decisiones de negocio.

## 📊 Dataset
- Fuente: Kaggle (E-Commerce Dataset, ~113k registros).
- Variables: Año, País, Categoría de producto, Precio unitario, Cantidad, Costo, Ingreso.

## ⚙️ Instalación
1. Clonar este repositorio:
   ```bash
   git clone https://github.com/benjamingaleano334/dashboard_r.git
   ```
2. Abrir RStudio en la carpeta del proyecto.
3. Instalar las librerías necesarias:
   ```r
   install.packages(c("shiny", "shinydashboard", "plotly", "DT", "dplyr"))
   ```

## ▶️ Uso local
1. Abrir el archivo `app.R` o el conjunto `ui.R`, `server.R`, `global.R`.
2. Ejecutar en RStudio:
   ```r
   shiny::runApp()
   ```
3. El dashboard se abrirá en tu navegador en `http://127.0.0.1:xxxx`.

## 🌐 Demo en línea
Podés ver el dashboard funcionando aquí:  
Dashboard en ShinyApps.io [(benjamingaleano334.shinyapps.io in Bing)](https://benjamingaleano334.shinyapps.io/dashboard_r/")

## 📑 Informe
El repositorio incluye el archivo `informe.pdf` con la narrativa del proyecto, audiencia objetivo, contexto y conclusiones.

## 👤 Autor
Benjamín – Trabajo Práctico Integrador de Ciencia de Datos
```

---

✅ Con esto tu repo queda súper completo:  
- **Código** (app en R Shiny).  
- **Informe PDF** con análisis.  
- **Demo online** en shinyapps.io.  
- **Captura visual** del dashboard.  

👉 Te recomiendo crear la carpeta `img/` en tu repo y guardar ahí la captura (`dashboard.png`) para que se muestre bien en GitHub.  

¿Querés que te prepare también un **ejemplo de captura rápida** del dashboard (con `png()` en R) para que la generes directamente desde tu app sin tener que sacar foto manual?
