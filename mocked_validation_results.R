mocked_validation_results <- list(
  list(
    name = "mtcars",
    description = "Motor Trend Car Road Tests",
    validations = list(
      list(id = 1, title = "No NA's inside mpg:carb columns", success = T, warning = F, viewer = table_view(mtcars)),
      list(id = 2, title = "am values equal 0 or 2 only", success = F, warning = F, viewer = table_view(mtcars, c('am'), c(1,2,3,18,19,20,26,27,28,29,30,31,32))),
      list(id = 3, title = "gear and carb values should equal 3 or 4", success = T, warning = F, viewer = table_view(mtcars)),
      list(id = 4, title = "Each row sum for am:vs columns is less or equal 2", success = T, warning = F, viewer = table_view(mtcars)),
      list(id = 5, title = "Each row sum for am:vs columns is less or equal 1", success = F, warning = F, viewer = table_view(mtcars, c('vs', 'am'), c(3,18,19,20,26,28,32))),
      list(id = 6, title = "For wt and qsec we have: abs(col) < 4 * sd(col)", success = T, warning = F, viewer = table_view(mtcars)),
      list(id = 7, title = "For wt and qsec we have: abs(col) < 2 * sd(col)", success = F, warning = F, viewer = table_view(mtcars, c('wt', 'qsec'), c(9,15,16,17))),
      list(id = 8, title = "Using mpg:carb mahalanobis distance for each observation is within 30 median absolute deviations from the median", success = T, warning = F, viewer = table_view(mtcars)),
      list(id = 9, title = "Using mpg:carb mahalanobis distance for each observation is within 3 median absolute deviations from the median", success = F, warning = F, viewer = table_view(mtcars, c('mpg', 'carb'), c(9,29))),
      list(id = 10, title = "Column drat has only positive values", success = T, warning = F, viewer = table_view(mtcars)),
      list(id = 11, title = "Column drat has only values larger than 3", success = F, warning = F, viewer = table_view(mtcars, c('drat'), c(6,15,16,22)))
    )
  ),
  list(
    name = "iris",
    description = "Validation can be just a warning, to notify you about potential problems. It doesn't have to fail the whole report status.",
    validations = list(
      list(id = 12, title = "Sepal length is greater than 0", success = T, warning = F, viewer = table_view(iris)),
      list(id = 13, title = "Sepal width is between 0 and 4", success = F, warning = T, viewer = table_view(iris, c('Sepal.Width'), c(16,33,34)))
    )
  ),
  list(
    name = "population",
    description = "We can visualize validation in different ways. Below you can see example with a leaflet map.",
    validations = list(
      list(id = 14, title = "Show warning for regions with more males than females in population", success = F, warning = T, viewer = custom_map_view(population, c(125,143,157,164,168,209,225,226,231,232,243,303,309,375)))
    )
  )
)

