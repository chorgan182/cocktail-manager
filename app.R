
library(shiny)
library(bslib)
library(shinyWidgets)

# theming
light <- bs_theme(version = 5)
dark <- bs_theme(version = 5,
                 bg = "black",
                 fg = "white",
                 primary = "purple")


ui <- navbarPage(

  title = "Cocktail Manager",
  theme = dark,

  ### enable for real-time theming
  #theme = bs_theme(),

  ### this needs to go in the header somehow
  switchInput(
    "theme_switch",
    value = TRUE,
    onLabel = icon("moon", "fa-solid"),
    offLabel = icon("moon", "fa-regular"),
    size = "mini"
  ),

  tabPanel("Cocktail List"),

  tabPanel("My Bar")

)


server <- function(input, output, session) {

  ### enable for real-time theming
  #bs_themer()

  observe(session$setCurrentTheme(
    if (isTRUE(input$theme_switch)) dark else light
  ))



}


shinyApp(ui, server)