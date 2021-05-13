table_view <- function(data, violated_column_names, violated_row_ids) {
  list(
    output = function(id) DTOutput(id),
    render = renderDT({
      data$violation <- FALSE
      if (length(violated_column_names) > 0 && length(violated_row_ids) > 0) {
        data[violated_row_ids,]$violation <- TRUE
      }
      data <- data[, c('violation', colnames(data))]
      datatable(data, options = list(order = list(list(1, 'desc')))) %>% 
        formatStyle(violated_column_names, 'violation', backgroundColor = styleEqual(c(TRUE, FALSE), c('#FFCCCB', '#D0F0C0')))
    })
  )
}


custom_map_view <- function(data, violated_row_ids) {
  list(
    output = function(id) leafletOutput(id, height = 500),
    render = renderLeaflet({
      
      correct_color <- "#52cf0a"
      violated_color <- "#bf0b4d"
      data$color <- correct_color
      if (length(violated_row_ids) > 0) data[violated_row_ids,]$color <- violated_color
      
      file <- system.file("extdata", "counties.json", package = "data.validator")
      states <- rgdal::readOGR(file, GDAL1_integer64_policy = TRUE, verbose = FALSE)
      states@data <- dplyr::left_join(states@data, data, by = c("JPT_KOD_JE" = "county_ID"))
      states@data$label <- glue::glue("County: {states@data$county} <br>", 
                                      "Female population: {states@data$females} <br>", 
                                      "Male population: {states@data$males}")
      
      leaflet::leaflet(states) %>%
        setView(lng = 19.5, lat = 52, zoom = 6) %>%
        leaflet::addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                             opacity = 0.5, fillOpacity = 0.5,
                             fillColor = states@data$color,
                             label = states@data$label %>% lapply(htmltools::HTML),
                             highlightOptions = leaflet::highlightOptions(color = "white",
                                                                          weight = 2,
                                                                          bringToFront = TRUE))
    })
  )
}










