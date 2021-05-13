library(assertr)
library(data.validator)

report <- data_validation_report()

validate(mtcars, description = "Motor Trend Car Road Tests") %>%
  validate_cols(not_na, mpg:carb, description = "No NA's inside mpg:carb columns") %>%
  validate_cols(in_set(c(0, 2)), am, description = "am values equal 0 or 2 only") %>%
  validate_rows(rowSums, within_bounds(0, 2), vs:am,
                description = "Each row sum for am:vs columns is less or equal 2") %>%
  validate_rows(rowSums, within_bounds(0, 1), vs:am,
                description = "Each row sum for am:vs columns is less or equal 1") %>%
  validate_cols(within_n_sds(4), wt, qsec, description = "For wt and qsec we have: abs(col) < 4 * sd(col)") %>%
  validate_cols(within_n_sds(2), wt, qsec, description = "For wt and qsec we have: abs(col) < 2 * sd(col)") %>%
  validate_rows(row_reduction_fn = maha_dist, within_n_mads(30), mpg:carb,
                description = paste("Using mpg:carb mahalanobis distance for each observation is within",
                                    "30 median absolute deviations from the median")) %>%
  validate_rows(row_reduction_fn = maha_dist, within_n_mads(3), mpg:carb,
                description = paste("Using mpg:carb mahalanobis distance for each observation is within",
                                    "3 median absolute deviations from the median")) %>%
  validate_if(drat > 0, description = "Column drat has only positive values") %>%
  validate_if(drat > 3, description = "Column drat has only values larger than 3") %>%
  add_results(report)

# Custom predicate
between <- function(a, b) {
  function(x) { a <= x && x <= b }
}

validate(iris, name = "Verifying flower dataset") %>%
  validate_if(Sepal.Length > 0, description = "Sepal length is greater than 0") %>%
  validate_cols(between(0, 4), Sepal.Width, description = "Sepal width is between 0 and 4") %>%
  add_results(report)


# Example of custom visualization
file <- system.file("extdata", "population.csv", package = "data.validator")
population <- read.csv(file, colClasses = c("character", "character", "character", "integer", "integer", "integer"))

validate(population, description = paste("Data.validator can visualize invalid data in differen ways.",
                                         "Below you can see example with a leaflet map")) %>%
    validate_cols(assertr::within_n_sds(3), total) %>%
    add_results(validator)

save_report(report)
