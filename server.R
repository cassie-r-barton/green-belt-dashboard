server <- function(input, output, session) {
  # Datasets and boundaries ------------------------------------------------

  # Obtain constituency code from the dropdown

  constituency_code <- reactive({
    row <- filter(
      gb_area,
      con_name == input$conSelect
    )

    return(row$ons_code[1])
  })

  # Stats on Green Belt extent

  area_dataset <- reactive({
    filter(
      gb_area,
      ons_code == constituency_code()
    )
  })

  # Constituency boundaries

  con_shape <- reactive({
    filter(
      cons,
      PCON24CD == constituency_code()
    )
  })

  # Green belt boundaries

  gb_shape <- reactive({

    shape <- read_sf(paste0(
      "./data/constituency_green_belt/",
      constituency_code(),
      "_gb.gpkg"
    ))
  })

  # Dynamic text -----------------------------------------------------------

  # Text that explains the amount of Green Belt (see R/ui_dynamic_text.R for function code)

  output$gb_text <- shiny::renderText({
    make_gb_area_text(area_data = area_dataset())
  })

  # Text that explains the amount of Green Belt in LAs (see R/ui_dynamic_text.R for function code)

  output$la_text <- shiny::renderText({
    make_la_text(la_data = gb_shape())
  })
  
  # Map header

  output$map_header <- renderText({
    make_map_header(area_data = area_dataset())
  })


  # LA table

  output$la_table <- renderDT({

    make_la_table(la_data = gb_shape())

  })
  # # Define the text that lists LAs

  #  # output$la_text <- shiny::renderUI({
  #  #
  #  #   make_la_text(la_data = gb_shape())
  #  #
  #  # })
  #  #
  #  # LA table

  # output$la_table <- renderTable({

  #   make_la_table(la_data = gb_shape())

  # })


# Map --------------------------------------------------------------------

  # Colour palette

  pal <-
    leaflet::colorNumeric(
      # palette = c("#3f9d8a", "#53B833", "#A6CD39"),
      palette = c("#3f9d8a", "#a37ec8", "#e09f00"),
      domain = 1:3
    )

  # Map

  output$con_map <- renderLeaflet(
    {
      leaflet(
        options = leafletOptions(
          zoomControl = FALSE,
          attributionControl = FALSE,
          minZoom = 9,
          maxZoom = 15
        )
      ) %>%

        addTiles(OSLight_3857) %>%

        addPolygons(
          data = con_shape(),

          fillOpacity = 0,

          opacity = 1,

          color = "#682f7f",

          weight = 4
        ) %>%

        addPolygons(
          data = gb_shape(),

          fillOpacity = 0.5,

          opacity = 1,

          fill = TRUE,

          fillColor = ~ pal(gb_shape()$map_id),

          weight = 0.5,

          color = ~ pal(gb_shape()$map_id),

          label = lapply(
            paste0("Green Belt land in ", gb_shape()$name, " local authority"),
            HTML
          ),

          labelOptions = labelOptions(
            style = list(
              "color" = "black",
              "font-family" = "Open Sans",
              "font-weight" = "bold",
              "font-size" = "13px",
              "border-color" = "rgba(0,0,0,0.5)"
            )
          )
        )
    }
  )
}
