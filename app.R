library(shiny)
library(shiny.fluent)
library(leaflet)
library(readr)
library(data.validator)
library(DT)
library(codeModules)
library(shiny.info)

source("viewers.R")

validation_code <- read_file("data_validation.R")

# TODO
# - refaktoring kodu aby wyglądał elegancko
# - poprawić działanie walidacji na mapie + prawdziwe uruchomienie walidatora przy inicjalizacji appki
# - deploy na shinyapps

makeCard <- function(title, content) {
  div(class = "card ms-depth-8",
      Stack(
        tokens = list(childrenGap = 5),
        Text(variant = "large", title, block = TRUE),
        content
      ))
}

validation_row <- function(id, text, success = TRUE, warning = FALSE) {
  if (success) {
    div(class="success",
      tagList(
        Separator(),
        ActionButton(paste0("validation_", id), iconProps = list("iconName" = "CheckMark"), text = text)
      )
    )
  } else if (warning) {
    div(class="warning",
      tagList(
        Separator(),
        div(
          ActionButton(paste0("validation_", id), iconProps = list("iconName" = "Warning12"), text = text),
          span(style="float: right",
               DefaultButton(paste0("inspect_", id), iconProps = list("iconName" = "Search"), text = "Inspect invalid data"))
        )
      )
    )
  } else {
    div(class="failure",
        tagList(
          Separator(),
          div(
            ActionButton(paste0("validation_", id), iconProps = list("iconName" = "Cancel"), text = text),
            span(style="float: right",
                 DefaultButton(paste0("inspect_", id), iconProps = list("iconName" = "Search"), text = "Inspect invalid data"))
          )
        )
    )
  }
}


mocked_validation_results <- list(
  list(title = "No NA's inside mpg:carb columns", success = T, warning = F, inspect = table_view(mtcars)),
  list(title = "am values equal 0 or 2 only", success = F, warning = F, inspect = table_view(mtcars, c('am'), c(1,2,3,18,19,20,26,27,28,29,30,31,32))),
  list(title = "gear and carb values should equal 3 or 4", success = T, warning = F, inspect = table_view(mtcars)),
  list(title = "Each row sum for am:vs columns is less or equal 2", success = T, warning = F, inspect = table_view(mtcars)),
  list(title = "Each row sum for am:vs columns is less or equal 1", success = F, warning = T, inspect = table_view(mtcars, c('vs', 'am'), c(3,18,19,20,26,28,32))),
  list(title = "For wt and qsec we have: abs(col) < 4 * sd(col)", success = T, warning = F, inspect = table_view(mtcars)),
  list(title = "For wt and qsec we have: abs(col) < 2 * sd(col)", success = F, warning = F, inspect = table_view(mtcars, c('wt', 'qsec'), c(9,15,16,17))),
  list(title = "Using mpg:carb mahalanobis distance for each observation is within 30 median absolute deviations from the median", success = T, warning = F, inspect = table_view(mtcars)),
  list(title = "Using mpg:carb mahalanobis distance for each observation is within 3 median absolute deviations from the median", success = F, warning = F, inspect = table_view(mtcars, c('mpg', 'carb'), c(9,29))),
  list(title = "Column drat has only positive values", success = T, warning = F, inspect = table_view(mtcars)),
  list(title = "Column drat has only values larger than 3", success = F, warning = F, inspect = table_view(mtcars, c('drat'), c(6,15,16,22))),
  list(title = "Sepal length is greater than 0", success = T, warning = F, inspect = table_view(iris)),
  list(title = "Sepal width is between 0 and 4", success = F, warning = F, inspect = table_view(iris, c('Sepal.Width'), c(16,33,34))),
  list(title = "Regions with 10.000+ cases are outliers", success = F, warning = T, inspect = custom_map_view())
)


layout <- div(class = "grid-container",
  div(class = "left_margin", ""),
  div(class = "main",
    tagList(
      shiny.info::display("Built for RStudio Shiny Contest 2021", position = "bottom right"),
      div(style = "margin: 20px 0",
        Text(variant = "xLarge", "Data Validation Report")
      ),
      div(style = "margin: 20px 0",
          span(style="float: left; margin-right: 20px;", PrimaryButton("button_status", iconProps = list("iconName" = "Cancel"), text = "Failed")),
          span(style="float: left; padding-top: 5px; margin-right: 5px", Toggle("toggle", FALSE, onChanged = JS("(checked) => checked ? $('.success').fadeOut(1000) : $('.success').fadeIn(1000)"))),
          span(style="float: left; padding-top: 5px", Text(variant = "medium", "Display errors and warnings only")),
          span(style="float: right",
               TooltipHost(
                 content = "Date when validation was performed",
                 delay = 0,
                 tagList(
                   FontIcon(iconName = "Clock"),
                   Text(" 2021-04-17 21:47:11 CET ")
                 )
               )
          )
      ),
      br(), br(),
      MessageBar(
        span(
          "This is a proof of concept of",
          Link(href = "https://github.com/Appsilon/data.validator", "data.validator"),
          " report using",
          Link(href = "https://github.com/Appsilon/shiny.fluent", "shiny.fluent"),
          " React.js components from",
          Link(href = "https://developer.microsoft.com/en-us/fluentui/", "Microsoft Fluent UI"),
          " library")
      ),
      br(),
      Pivot(
        PivotItem(headerText = "Validation Results",
          ShinyComponentWrapper(
            tagList(
              Separator(),
              makeCard("mtcars",
                 tagList(
                   Text(variant = "medium", "Motor Trend Car Road Tests"),
                   lapply(1:11, function(id) {
                     result <- mocked_validation_results[[id]]
                     validation_row(id, result$title, success = result$success, warning = result$warning)
                   })
                 )
              ),
              makeCard("iris",
                 tagList(
                   Text(variant = "medium", "Verifying flower dataset"),
                   lapply(12:13, function(id) {
                     result <- mocked_validation_results[[id]]
                     validation_row(id, result$title, success = result$success, warning = result$warning)
                   })
                 )
              ),
              makeCard("population",
                 tagList(
                   Text(variant = "medium", "We can visualize validation in different ways. Below you can see example with a leaflet map. Also validation can be just a warning, to notify you about potential problems. It doesn't have to fail the whole report status."),
                   lapply(14:14, function(id) {
                     result <- mocked_validation_results[[id]]
                     validation_row(id, result$title, success = result$success, warning = result$warning)
                   })
                 )
              )
            )
          )
        ),
        PivotItem(headerText = "Code",
          ShinyComponentWrapper(
            tagList(
              Separator(),
              makeCard("Code used to validate the data and generate this report",
                tagList(
                  br(),
                  uiOutput("code")
                  # Być może też renderCode zadziała jak to będzie naprawione
                  # https://statistikat.github.io/codeModules/reference/renderCode.html#examples
                )
              )
            )
          )
        )
      )
    ),
    reactOutput("reactModal")
  ),
  div(class = "right_margin", "")
)

ui <- fluidPage(
  suppressDependencies("bootstrap"),
  tags$head(
    tags$link(href = "style.css", rel = "stylesheet", type = "text/css")
  ),
  htmltools::htmlDependency(
    "office-ui-fabric-core",
    "11.0.0",
    list(href="https://static2.sharepointonline.com/files/fabric/office-ui-fabric-core/11.0.0/css/"),
    stylesheet = "fabric.min.css"
  ),
  shiny::tags$body(
    class = "ms-Fabric",
    dir="ltr",
    withReact(layout)
  )
)

server <- function(input, output, session) {

  inspected_validation <- reactiveVal(NULL)

  lapply(
    X = 1:14,
    FUN = function(i) {
      input_id <- paste0("inspect_", i)
      observeEvent(input[[input_id]], {
        isModalOpen(TRUE)
        inspected_validation(i)
      })
    }
  )
  
  # https://statistikat.github.io/codeModules/reference/renderCode.html
  output$code_out <- renderCode({
    validation_code
  })
  
  # renderUI is a hack
  # we are not handling HTML() directly, because to add raw HTML in React you have to use __dangerouslySetInnerHTML__
  # it will be fixed in the next versions of shiny.fluent
  output$code <- renderUI({
    codeOutput("code_out")
  })
  
  output$inspect_render_1 <- mocked_validation_results[[1]]$inspect$render
  output$inspect_render_2 <- mocked_validation_results[[2]]$inspect$render
  output$inspect_render_3 <- mocked_validation_results[[3]]$inspect$render
  output$inspect_render_4 <- mocked_validation_results[[4]]$inspect$render
  output$inspect_render_5 <- mocked_validation_results[[5]]$inspect$render
  output$inspect_render_6 <- mocked_validation_results[[6]]$inspect$render
  output$inspect_render_7 <- mocked_validation_results[[7]]$inspect$render
  output$inspect_render_8 <- mocked_validation_results[[8]]$inspect$render
  output$inspect_render_9 <- mocked_validation_results[[9]]$inspect$render
  output$inspect_render_10 <- mocked_validation_results[[10]]$inspect$render
  output$inspect_render_11 <- mocked_validation_results[[11]]$inspect$render
  output$inspect_render_12 <- mocked_validation_results[[12]]$inspect$render
  output$inspect_render_13 <- mocked_validation_results[[13]]$inspect$render
  output$inspect_render_14 <- mocked_validation_results[[14]]$inspect$render

  output$inspected_validation_title <- renderText({ 
    mocked_validation_results[[inspected_validation()]]$title
  })

  output$display_validation_result <- renderUI({
    if (isModalOpen()) {
      output_id <- paste0("inspect_render_", inspected_validation())
      mocked_validation_results[[inspected_validation()]]$inspect$output(output_id)
    } else {
      ""
    }
  })

  isModalOpen <- reactiveVal(FALSE)
  output$reactModal <- renderReact({
    reactWidget(
      Modal(isOpen=isModalOpen(), isBlocking=FALSE, className = "validation-details-modal",
        div(style = "margin: 20px",
          h1(style = "float: left; margin: 0 0 30px 0", textOutput("inspected_validation_title")),
          br(),
          div(style = "position: relative",
            div(style = "position: absolute; width: 100%; padding-top: 100px", Spinner(size = 3, label = "Loading, please wait...")),
            uiOutput("display_validation_result")
          ),
          div(style = "float: right; margin-top: 50px", ShinyComponentWrapper(DefaultButton("hideModal", text="Close")))
        )
      )
    )
  })
  observeEvent(input$hideModal, { isModalOpen(FALSE) })

}

shinyApp(ui, server)
