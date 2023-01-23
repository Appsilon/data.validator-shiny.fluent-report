library(shiny)
library(shiny.fluent)
library(leaflet)
library(readr)
library(data.validator)
library(DT)
library(codeModules)
library(shiny.info)

# Load functions responsible for different ways of displaying errors in data
source("viewers.R")
source("about.R")

# Run data validation
# source("data_validation.R")
# NOTE: Current version of data.validator report object needs refactoring to be more convenient
#       to use here. For the purpose of the POC I am mocking the example result (using real validator output), 
#       to firstly research how users like the shiny.fluent report app before I invest more time into that.
source("mocked_validation_results.R")


Card <- function(title, content) {
  div(class = "card ms-depth-8",
    Stack(
      tokens = list(childrenGap = 5),
      Text(variant = "large", title, block = TRUE),
      content
    )
  )
}

ValidationStatusRow <- function(id, text, success = TRUE, warning = FALSE) {
  config <- list(
    success = list(class = "success", icon = "CheckMark", iconClass = "successIcon"),
    warning = list(class = "warning", icon = "Warning12", iconClass = "warningIcon"),
    failure = list(class = "failure", icon = "Cancel", iconClass = "failureIcon")
  )
  
  params <- if (success) config$success else if (warning) config$warning else config$failure
  
  div(className = params$class,
    tagList(
      Separator(),
      div(
        ActionButton(
          paste0("validation_", id), 
          iconProps = list("iconName" = params$icon), 
          text = text,
          className = params$iconClass
        ),
        if (success) NULL else div(style = "float: right", DefaultButton.shinyInput(
          paste0("open_viewer_button_", id),
          iconProps = list("iconName" = "Search"),
          text = "Inspect invalid data"
        ))
      )
    )
  )
}

ValidationStatusSection <- function(name, description, validations) {
  Card(name,
    tagList(
      Text(variant = "medium", description),
      lapply(validations, function(result) {
        ValidationStatusRow(result$id, result$title, success = result$success, warning = result$warning)
      })
    )
  )
}

layout <- function(body) {
  div(class = "grid-container",
    div(class = "left_margin", ""),
    div(class = "main", body),
    div(class = "right_margin", "")
  )
}

report <- tagList(
  shiny.info::display("Built for RStudio Shiny Contest 2021", position = "bottom right"),
  div(
    class = "navbar",
    style = "margin: 20px 0",
    Text(variant = "xLarge", "Data Validation Report"),
    about_ui("about_section")
  ),
  div(style = "margin: 20px 0",
      span(id = "report_status", style = "float: left; margin-right: 20px;",
        PrimaryButton(iconProps = list("iconName" = "Cancel"), text = "Failed")
      ),
      span(style = "float: left; padding-top: 5px; margin-right: 5px", 
        Toggle("toggle", FALSE, 
               onChanged = JS("(checked) => checked ? $('.success').fadeOut(1000) : $('.success').fadeIn(1000)"))
      ),
      span(style = "float: left; padding-top: 5px",
        Text(variant = "medium", "Display errors and warnings only")
      ), 
      span(style="float: right",
        TooltipHost(content = "Date when validation was performed", delay = 0, 
                    tagList(FontIcon(iconName = "Clock"), Text(" 2021-05-14 17:00:00 ET ")))
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
      tagList(
        Separator(),
        lapply(mocked_validation_results, function(result) {
          ValidationStatusSection(result$name, result$description, result$validations)
        })
      )
    ),
    PivotItem(headerText = "Code",
      tagList(
        Separator(),
        Card("Code used to validate the data and generate this report", uiOutput("code"))
      )
    )
  ),
  reactOutput("reactModal")
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
    layout(
      report
    )
  )
)

server <- function(input, output, session) {
  
  about_server("about_section")
  
  # Flatten results to one list
  validation_results <- lapply(mocked_validation_results, function(x) x$validations) %>% do.call(c, .)
  
  # Set observers for button click to open 
  # validation viewer modal with appropriate validation
  inspected_validation <- reactiveVal(NULL)
  lapply(validation_results, function(result) {
      input_id <- paste0("open_viewer_button_", result$id)
      observeEvent(input[[input_id]], {
        isModalOpen(TRUE)
        inspected_validation(result$id)
      })
    }
  )
  
  for (result in validation_results) {
    output[[paste0("validation_viewer_", result$id)]] <- result$viewer$render
  }
  
  output$code_out <- renderCode({ # from codeModules
    read_file("data_validation.R")
  })
  
  # NOTE: renderUI used below is a hack
  # We can't support some outputs in shiny.fluent, e.g. HTML() directly, 
  # because to add raw HTML in React you have to use __dangerouslySetInnerHTML__
  # which is not yet implemented. RenderUI is implemented, so it can be used as workaround.
  output$code <- renderUI({
    codeOutput("code_out") # from codeModules
  })

  output$inspected_validation_title <- renderText({ 
    validation_results[[inspected_validation()]]$title
  })

  output$display_validation_result <- renderUI({
    if (isModalOpen()) {
      output_id <- paste0("validation_viewer_", inspected_validation())
      validation_results[[inspected_validation()]]$viewer$output(output_id)
    } else {
      ""
    }
  })

  isModalOpen <- reactiveVal(FALSE)
  
  output$reactModal <- renderReact({
    Modal(
      isOpen = isModalOpen(),
      isBlocking = FALSE,
      className = "validation-details-modal",
      div(
        style = "margin: 20px",
        h1(style = "float: left; margin: 0 0 30px 0", 
           textOutput("inspected_validation_title")),
        br(),
        div(style = "position: relative",
          div(style = "position: absolute; width: 100%; padding: 200px 0", 
              Spinner(size = 3, label = "Loading, please wait...")),
          uiOutput("display_validation_result")
        ),
        div(style = "float: right; margin-top: 50px",
          DefaultButton.shinyInput("hideModal", text = "Close")
        )
      )
    )
  })
  
  observeEvent(input$hideModal, {
    isModalOpen(FALSE)
  })

}

shinyApp(ui, server)
