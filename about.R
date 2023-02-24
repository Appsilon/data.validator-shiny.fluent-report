create_image_path <- function(path) {
  base_path <- "img"
  sprintf(
    fmt = "../%s/%s",
    base_path,
    path
  )
}

topic_section <- function(header,
                          description) {
  div(
    h4(class = "about-header", header),
    div(
      class = "about-descr",
      description
    )
  )
}

tag <- function(tag_string, hyperlink) {
  div(
    class = "tag-item",
    icon("link"),
    a(
      href = hyperlink,
      target = "_blank",
      rel = "noopener noreferrer",
      tag_string
    )
  )
}

card <- function(href_link,
                 img_link,
                 card_header,
                 card_text) {
  div(
    class = "card-package",
    a(
      class = "card-img",
      href = href_link,
      target = "_blank",
      rel = "noopener noreferrer",
      img(
        src = img_link,
        alt = card_header
      )
    ),
    div(
      class = "card-heading",
      card_header
    ),
    div(
      class = "card-content",
      card_text
    ),
    a(
      class = "card-footer",
      href = href_link,
      target = "_blank",
      rel = "noopener noreferrer",
      "Learn more"
    )
  )
}

empty_card <- function() {
  div(
    class = "card-empty",
    a(
      href = "https://shiny.tools/#rhino",
      target = "_blank",
      rel = "noopener noreferrer",
      shiny::icon("arrow-circle-right"),
      div(
        class = "card-empty-caption",
        "More Appsilon Technologies"
      )
    )
  )
}

appsilon <- function() {
  div(
    class = "appsilon-card",
    div(
      class = "appsilon-pic",
      a(
        href = "https://appsilon.com/",
        target = "_blank",
        rel = "noopener noreferrer",
        img(
          src = create_image_path("appsilon-logo.png"),
          alt = "Appsilon"
        )
      )
    ),
    div(
      class = "appsilon-summary",
      "We create, maintain, and develop Shiny applications
      for enterprise customers all over the world. Appsilon
      provides scalability, security, and modern UI/UX with
      custom R packages that native Shiny apps do not provide.
      Our team is among the world’s foremost experts in R Shiny
      and has made a variety of Shiny innovations over the
      years. Appsilon is a proud Posit Full Service
      Certified Partner."
    )
  )
}

#' @export
about_ui <- function(id) {
  ns <- NS(id)

  tagList(
    reactOutput(ns("modal")),
    IconButton.shinyInput(
      ns("open_modal"),
      iconProps = list(
        iconName = "Info"
      )
    ),
    tags$script(
      HTML(
        sprintf(
          fmt = "$('#info').click(() => {
            Shiny.setInputValue('%s', 'event', { priority: 'event'})
          })",
          ns("open_modal")
        )
      )
    )
  )
}

#' @export
about_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    modal_visible <- reactiveVal(FALSE)
    observeEvent(input$hide_modal, modal_visible(FALSE))

    output$modal <- renderReact({
      Modal(
        isOpen = modal_visible(),
        isBlocking = FALSE,
        isModeless = TRUE,
        div(
          class = "modal-dialog",
          div(
            class = "modal-title",
            "Data Validation Report",
            div(
              class = "about-close-btn",
              id = "about-close",
              ActionButton.shinyInput(
                ns("hide_modal"),
                iconProps = list("iconName" = "Cancel"),
                text = "Close"
              )
            )
          ),
          div(
            class = "about-section",
            topic_section(
              header = "About the project",
              description = "This R Shiny dashboard explores
              The various possibilities of the data.validation
              package created by Appsilon; which is useful to
              validate your dataset."
            ),
            topic_section(
              header = "Dataset Info",
              description = "The data used in the app are
              one of the very famous datasets; like iris and mtcars."
            ),
            hr(),
            div(
              h4(
                class = "about-header",
                "Powered by"
              ),
              div(
                class = "card-section",
                card(
                  href_link = "https://appsilon.github.io/shiny.fluent/",
                  img_link = create_image_path("shiny-fluent.png"),
                  card_header = "shiny.fluent",
                  card_text = "We believe that a great UI plays a huge
                  role in the success of application projects. Shiny.fluent
                  gives your apps a beautiful, professional look, rich set
                  of components easily usable in Shiny, and fast speed of
                  development that Shiny is famous for. As Fluent UI is built
                  in React, shiny.fluent is based on another package called
                  shiny.react, which allows for using React libraries in Shiny."
                ),
                card(
                  href_link = "https://appsilon.github.io/shiny.react/",
                  img_link = create_image_path("shiny-react.png"),
                  card_header = "shiny.react",
                  card_text = "Most of the shiny apps are build directly
                  in Shiny without using any JS library. React being the
                  Most popular one becomes one of such candidate.
                  This R package enables using React in Shiny apps and is
                  used e.g. by the shiny.fluent package. It contains R and JS
                  code which is independent from the React library
                  (e.g. Fluent UI) that is being wrapped."
                ),
                card(
                  href_link = "https://appsilon.github.io/data.validator/",
                  img_link = create_image_path("data-validator.png"),
                  card_header = "data.validator",
                  card_text = "Validate your data and create nice reports
                  straight from R. data.validator is a package for scalable
                  and reproducible data validation. It Create report object,
                  prepare your dataset and validate your dataset along with
                  genating HTML reports."
                )
              )
            ),
            appsilon()
          )
        )
      )
    })

    observeEvent(input$open_modal, {
      modal_visible(TRUE)
    })
  })
}
