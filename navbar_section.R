# The application header.
# Includes branding and navigation

#' @export
navbar_ui <- function(id) {
  
  ns <- NS(id)
  
  # A single header menu item
  nav_item <- function(input_id, label) {
    actionButton(input_id, label, class = "btn-nav_menu")
  }
  
  # Use breakpoints based on the Appsilon design system
  appsilon_breakpoints <- breakpointSystem(
    "appsilon-breakpoints",
    breakpoint("xs", min = 320),
    breakpoint("s", min = 428),
    breakpoint("m", min = 728),
    breakpoint("l", min = 1024),
    breakpoint("xl", min = 1200)
  )
  
  gridPanel(
    # Layout definition START
    id = "app_header",
    
    # Used for mobile collapsed menu logic
    class = "mobile-collapsed",
    
    # Panel breakpoint system
    breakpoint_system = appsilon_breakpoints,
    
    # CSS grid areas of the panel.
    # Appsilon breakpoints are mobile first, so our default
    # is the mobile version of the panel
    areas = list(
      default = c(
        "logo . info mobile_controls",
        "separator separator separator separator",
        "title title title title",
        "menu menu menu menu",
        "cta cta cta cta"
      ),
      l = "logo separator title mobile_controls . menu info cta"
    ),
    
    # CSS grid columns of the panel.
    # Appsilon breakpoints are mobile first, so our default
    # is the mobile version of the panel
    columns = list(
      default = "auto 1fr auto auto",
      l = "auto 1px auto auto 1fr auto auto auto"
    ),
    
    # CSS grid rows of the panel.
    # Appsilon breakpoints are mobile first, so our default
    # is the mobile version of the panel
    rows = list(
      default = "auto auto auto auto auto",
      l = "40px"
    ),
    
    # CSS grid gap of the panel.
    # Appsilon breakpoints are mobile first, so our default
    # is the mobile version of the panel
    gap = list(
      default = "0px",
      l = "16px"
    ),
    # Layout definition END
    
    # Header Content START
    # Appsilon logo
    logo = img(
      class = "appsilon_logo",
      src = "img/appsilon-logo.png"
    ),
    
    # Separator between logo and title.
    # On mobile it becomes the expanded separator
    separator = div(class = "app_header_vertical_separator mobile-toggled"),
    
    # Application title to be displayed
    title = div("Racial Diversity in the USA 2010-2019",
                class = "app_header_title mobile-toggled"
    ),
    
    # The call to action button
    cta = actionButton("cta_talk", "Let's Talk",
                       class = "btn-primary btn-cta mobile-toggled",
                       onclick = "window.open('https://appsilon.com/', '_blank')"
    ),
    
    # The info icon
    info = div(
      id = "cta_info",
      class = "cta-icon",
      about_ui(ns("about_section"))
    ),
    
    # The navigation
    menu = flexPanel(
      breakpoint_system = appsilon_breakpoints,
      class = "mobile-toggled",
      
      direction = list(
        default = "column",
        l = "row"
      ),
      
      nav_item(
        "menu_item_one",
        div("")
      )
    ),
    # Header Content END
    
    # Mobile controls START
    mobile_controls = div(
      # Collapse/Expand functionality for mobile
      tags$script("
        let header_expand = function() {
          document.getElementById('app_header')
            .classList
            .remove('mobile-collapsed');
          document.getElementById('app_header').classList
            .add('mobile-expanded');
        }

        let header_collapse = function() {
          document.getElementById('app_header')
            .classList
            .add('mobile-collapsed');
          document.getElementById('app_header')
            .classList
            .remove('mobile-expanded');
        }
      "),
      
      # Hamburger icon. Used on mobile to expand the header bar
      icon(
        "bars",
        class = "header_control header_expand cta-icon",
        onclick = "header_expand();"
      ),
      
      # Hamburger icon. Used on mobile to collapse the header bar
      icon(
        "times",
        class = "header_control header_collapse cta-icon",
        onclick = "header_collapse();"
      )
    )
    # Mobile controls END
  )
}

#' @export
navbar_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    about_server("about_section")
    return(reactive(input$show_filters))
  })
}
