library(leaflet)
# Choices for drop-downs
vars <- c(
  "ACT LPI" = "liveable_h",
  "LPI Score - Composite" = "centile",
  "School" = "school",
  "Median income" = "income",
  "Population" = "adultpop"
)


navbarPage("Where would you like to live in Canberra?", id="nav",

  tabPanel("Explore Canberra's Liveability interactively",
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width="200%", height="100%"),

      # Shiny versions prior to 0.11 should use class="modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",

        h2("ACT Liveability Profile Index"),

        selectInput("color", "Color", vars),
        selectInput("size", "Size", vars, selected = "adultpop"),
        conditionalPanel("input.color == 'liveable_h' || input.size == 'liveable_h'",
          # Only prompt for threshold when coloring or sizing by liveable_h
          numericInput("threshold", "liveability threshold (top n %)", 5)
        ),

        plotOutput("histCentile", height = 200),
        plotOutput("scatterschoolIncome", height = 250)
      ),

      tags$div(id="cite",
        'Data compiled for ', tags$em('ACT region, Australia'), 'DIISCOVER'
      )
    )
  ), 
  
    tabPanel("Search by Suburb - Detailed Info",
              fluidRow(
                  column(3,
                         conditionalPanel("input.states",
                                          selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
                         )
                  ),
      column(3,
        conditionalPanel("input.states",
          selectInput("postcode", "postcode", c("All postcode"=""), multiple=TRUE)
        )
      )
    ),
    fluidRow(
      column(1,
        numericInput("minScore", "Min score", min=0, max=100, value=0)
      ),
      column(1,
        numericInput("maxScore", "Max score", min=0, max=100, value=100)
      )
    ),
    hr(),
    DT::dataTableOutput("ziptable")
  ),

  conditionalPanel("false", icon("crosshair"))
)
