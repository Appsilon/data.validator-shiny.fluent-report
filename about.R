section_card <- function(
    title,
    hyperlink,
    image,
    header_text,
    description,
    image_width = "100px",
    image_height = "100px"
) {
  div(
    class = "card ms-depth-8",
    Stack(
      tokens = list(childrenGap = 10),
      a(
        href = hyperlink,
        class = "about_card_headers",
        span(
          class = "ms-fontWeight-regular ms-fontSize-20",
          title
        )
      ),
      Stack(
        wrap = FALSE,
        horizontal = TRUE,
        horizontalAlign = TRUE,
        verticalFill = TRUE,
        tokens = list(childrenGap = 12),
        a(
          href = hyperlink,
          Image(
            src = image,
            width = image_width,
            height = image_height
          )
        ),
        Stack(
          tokens = list(childrenGap = 5),
          Text(
            variant = "large", header_text,
            block = TRUE
          ),
          Text(
            description
          )
        )
      )
    )
  )
}

shiny_appsilon_card <- section_card(
  title = "Appsilon",
  hyperlink = "https://appsilon.com/",
  image = "img/appsilon-logo.png",
  header_text = "This Project is Developed By Appsilon",
  description =
    "We create, maintain, and develop Shiny applications for
  enterprise customers all over the world. Appsilon provides
  scalability, security, and modern UI/UX with custom R
  packages that native Shiny apps do not provide. Our team is
  among the world’s foremost experts in R Shiny and has made
  a variety of Shiny innovations over the years. Appsilon is
  a proud RStudio (Posit) Full Service Certified Partner.",
  image_height = "50px"
)

shiny_fluent_card <- section_card(
  title = "shiny.fluent",
  hyperlink = "https://appsilon.github.io/shiny.fluent/index.html",
  image = "img/shiny-fluent.png",
  header_text = "Check the rest of the App to Learn More...",
  description =
    "We believe that a great UI plays a huge role in the success of
  application projects. shiny.fluent gives your apps: - beautiful,
  professional look - rich set of components easily usable in Shiny -
  fast speed of development that Shiny is famous for. As Fluent UI is
  built in React, shiny.fluent is based on another package called
  shiny.react, which allows for using React libraries in Shiny."
)

shiny_react_card <- section_card(
  title = "shiny.react",
  hyperlink = "https://appsilon.github.io/shiny.react/",
  image = "img/shiny-react.png",
  header_text = "handshake between React and Shiny",
  description =
    "Most of the shiny apps are build directly in Shiny
  without using any JS library. React being the Most popular one
  becomes one of such candidate.
  This R package enables using React in Shiny apps and is
  used e.g. by the shiny.fluent package. It contains R and JS
  code which is independent from the React library
  (e.g. Fluent UI) that is being wrapped."
)

data_validator_card <- section_card(
  title = "data.validator",
  hyperlink = "https://appsilon.github.io/data.validator/",
  image = "img/data-validator.png",
  header_text = "Validate your data in R",
  description =
  "Validate your data and create nice reports straight from R. data.validator
  is a package for scalable and reproducible data validation. It Create report object,
  prepare your dataset and validate your dataset along with genating HTML reports."
)

about_page <- div(
  style = "padding: 1rem 2rem 1rem 2rem;",
  shiny_appsilon_card,
  data_validator_card,
  shiny_fluent_card,
  shiny_react_card
)

#' @export
about_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    reactOutput(ns("about_model")),
    IconButton.shinyInput(
      style = "float: 'right';",
      ns("show_about"),
      iconProps = list(
        iconName = "Info",
        style = list(
          fontSize = 30
        )
      )
    )
  )
}

#' @export
about_server <- function(id) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      ns <- session$ns
      
      is_modal_open <- reactiveVal(FALSE)
      
      observeEvent(input$show_about, {
        is_modal_open(TRUE)
      })
      
      observeEvent(input$hide_modal, {
        is_modal_open(FALSE)
      })
      
      output$about_model <- renderReact({
        Modal(
          containerClassName = "about-modal",
          isOpen = is_modal_open(),
          div(
            div(
              class = "card-header",
              div(
                class = "card-header-left",
                Text(variant = "xLarge", "About Section", block = TRUE)
              ),
              div(class = "card-header-center"),
              div(
                class = "card-header-right",
                IconButton.shinyInput(
                  inputId = ns("hide_modal"),
                  iconProps = list(
                    iconName = "Cancel",
                    style = list(
                      fontSize = 24
                    )
                  )
                )
              )
            ),
            about_page
          )
        )
      })
    }
  )
}
