ui <- function(request) {

  page_fluid(

# CSS and title --------------------------------------------------------------------
    tags$head(tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "style.css"
    )),

    title = "Green belt by constituency",

  # Constituency selector -------------------------------------

    layout_columns(
      col_widths = c(7),
      div(
        class = "picker", 
        pickerInput(
          "conSelect", 
          "Select a constituency", 
          choices = gb_area$con_name, 
          selected = first(gb_area$con_name), 
          options = list(
            `live-search` = TRUE, 
            size = 15,  
            width = "150%"
          )
        ) |>
          # Add HTML attributes (styling + accessibility)
          tagAppendAttributes(
            style = "margin-bottom:-5px;",
            tabindex = 0
          )
      )
    ),


# Text section -----------------------------------------------------------

    layout_columns(
          col_widths = c(12),
          
          textOutput("gb_text") |>
            tagAppendAttributes(
              style = "margin-bottom:-10px",
              tabindex = 0
            ),
            
          # textOutput("la_text") |>
          #   tagAppendAttributes(
          #     style = "margin-bottom:-10px",
          #     tabindex = 0
          #   ),

            p("The table below shows which local authorities are responsible for Green Belt land in the constituency, and the map below shows where Green Belt land is located. Use the links in the table to see a more detailed local authority map on the planning.gov.uk website.") |>
            tagAppendAttributes(
              style = "margin-bottom:-10px",
              tabindex = 0
            ),
      
      DTOutput("la_table")

          ),


# Map section -----------------------------------------------------------

layout_columns(
  col_widths = c(12),

  h2(textOutput("map_header")) |>
            tagAppendAttributes(
              style = "margin-bottom:-15px;margin-top:25px",
              tabindex = 0
           ),

  leafletOutput("con_map", height = 700),

  span(style ="font-size: 9pt;",
                p("Contains Ordnance Survey data © Crown copyright and database rights 2026 OS [AC0000813358].")) |>
            tagAppendAttributes(
              style = "margin-bottom:-10px",
              tabindex = 0
            )

  )
  
  )
}