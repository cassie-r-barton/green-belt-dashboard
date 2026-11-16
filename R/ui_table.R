
# Table ------------------------------------------------------------------

make_la_table <- function(la_data) {

table_data <- la_data |> 
  select(c(name, area)) |> 
  rename(
    `Local authority` = name
    ) |> 
  mutate(
    `Percentage of total constituency Green Belt` = area / sum(area),
    `Link to local authority map` = "URL goes here"
  ) |> 
    select(-c(area)) |> 
    arrange(desc("Percentage of total constituency Green Belt")) |> 
    select(-c(geom))
  
DT::datatable(

    table_data, 
  
    rownames = FALSE,
    options = list(
      dom = 'tp',
      paging = FALSE, 
      scrollY = "150px", 
      filter = "none" 
    ),
    class = "compact",
    selection = "none" 
  ) |> 
  
  formatPercentage(columns = "Percentage of total constituency Green Belt", digits = 0)

}