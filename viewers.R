table_view <- function(data, violated_cols = c(), violated_rows = c()) {
  list(
    output = function(id) DTOutput(id),
    render = renderDT({
      data$error <- FALSE
      if (length(violated_cols) > 0 && length(violated_rows) > 0) {
        data[violated_rows,]$error <- TRUE
      }
      data <- data[, c('error', colnames(data))]
      datatable(data, options = list(order = list(list(1, 'desc')))) %>% 
        formatStyle(violated_cols, 'error', backgroundColor = styleEqual(c(TRUE, FALSE), c('#FFCCCB', '#D0F0C0')))
    })
  )
}


custom_map_view <- function() {
  list(
    output = function(id) leafletOutput(id, height = 500),
    render = renderLeaflet({
      file <- system.file("extdata", "population.csv", package = "data.validator")
      population <- read.csv(file, colClasses = c("character", "character", "character", "integer", "integer", "integer"))
      report <- data_validation_report()
      
      value_is_too_high <- function() {
        function(x) { x > 30000 }
      }
      
      validate(population) %>%
        validate_cols(value_is_too_high(), total) %>%
        add_results(report)
      
      file <- system.file("extdata", "counties.json", package = "data.validator")
      states <- rgdal::readOGR(file, GDAL1_integer64_policy = TRUE, verbose = FALSE)
      
      validation_results <- report$get_validations()[1,]
      
      violated <- validation_results %>%
        tidyr::unnest(error_df, keep_empty = TRUE) %>%
        dplyr::pull(index)
      
      correct_col <- "#52cf0a"
      violated_col <- "#bf0b4d"
      
      states@data <- dplyr::left_join(states@data, population, by = c("JPT_KOD_JE" = "county_ID"))
      states@data$color <- correct_col
      #states@data$color[violated] <- violated_col
      states@data$color[sample(100, 10)] <- violated_col
      states@data$label <- glue::glue("County: {states@data$county} <br>", "Population: {states@data$total}")
      
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










