
# Intro text -------------------------------------------------------------

# Function to make basic descriptive text about Green Belt area

make_gb_area_text <- function (area_data) {
  
    paste0(area_data$con_name,
          " has ",
          prettyNum(area_data$green_belt_ha, big.mark=","),
          " hectares of Green Belt land. This represents ",
          label_percent()(area_data$pc_green_belt/100),
          " of land in the constituency."
          )
  
}

# In progress. This could even have colour formatting to make it a map key...
make_la_text <- function(la_data) {
  # Guard: ensure required columns exist
  stopifnot(all(c("name", "area") %in% names(la_data)))
  
  # Total greenbelt area (all LAs combined)
  total_area <- sum(la_data$area, na.rm = TRUE)
  
  # Edge case: no area or total is zero
  if (is.na(total_area) || total_area == 0) {
    return("No measurable Green Belt area found for these local authorities.")
  }
  
  # Build one sentence per authority
  sentences <- la_data %>%
    dplyr::group_by(name) %>%
    dplyr::summarise(area = sum(area, na.rm = TRUE), .groups = "drop") %>%
    dplyr::mutate(
      pct = area / total_area,
      pct_text = scales::percent(pct),
      sentence = glue::glue(
        "{pct_text} of the constituency’s Green Belt sits within {name} local authority."
      )
    ) %>%
    dplyr::arrange(dplyr::desc(pct)) %>%
    dplyr::pull(sentence)
  
  # Return each sentence on a new line
  paste(sentences, collapse = "\n")
}


# Map header -------------------------------------------------------------

make_map_header <- function(area_data) {

  paste0("Green Belt boundaries in ", area_data$con_name)

}