library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
zipdata <- allzips[sample.int(nrow(allzips), 31),]
# By ordering by centile, we ensure that the (comparatively rare) liveable_hs
# will be drawn last and thus be easier to see
zipdata <- zipdata[order(zipdata$centile),]

function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = 149.5109, lat = -35.30965
              , zoom = 11)
  })

  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(zipdata[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)

    subset(zipdata,
      latitude >= latRng[1] & latitude <= latRng[2] &
        longitude >= lngRng[1] & longitude <= lngRng[2])
  })

  # Precalculate the breaks we'll need for the two histograms
  centileBreaks <- hist(plot = FALSE, allzips$centile, breaks = 20)$breaks

  output$histCentile <- renderPlot({
    # If no postcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)

    hist(zipsInBounds()$centile,
      breaks = centileBreaks,
      main = "Australian Capital Territory Livability Score ",
      xlab = "Percentile",
      xlim = range(allzips$centile),
      col = '#00FF00',
      border = 'white')
  })

  output$scatterschoolIncome <- renderPlot({
    # If no postcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)

    print(xyplot(income ~ school, data = zipsInBounds(), xlim = range(allzips$school), ylim = range(allzips$income)))
  })

  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size 

    if (colorBy == "liveable_h") {
      # Color and palette are treated specially in the "liveable_h" case, because
      # the values are categorical instead of continuous.
      colorData <- ifelse(zipdata$centile >= (100 - input$threshold), "yes", "no")
      pal <- colorFactor("viridis", colorData)
    } else {
      colorData <- zipdata[[colorBy]]
      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    }

    if (sizeBy == "liveable_h") {
      # Radius is treated specially in the high livable.
      radius <- ifelse(zipdata$centile >= (100 - input$threshold), 3000, 300)
    } else {
      radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 2000
    }

    leafletProxy("map", data = zipdata) %>%
        
      clearShapes() %>%
        
      addCircles(~longitude, ~latitude, radius=radius, layerId=~postcode,
        stroke=FALSE, fillOpacity=0.5, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
        layerId="colorLegend")
  })

  # Show a popup at the given location
  showpostcodePopup <- function(postcode, lat, lng) {
    select_postcode <- allzips[allzips$postcode == postcode,]
    content <- as.character(tagList(
      tags$h4("Score:", as.integer(select_postcode$centile)),
      tags$strong(HTML(sprintf("%s, %s %s",
        select_postcode$city.x, select_postcode$state.x, select_postcode$postcode
      ))), tags$br(),
      sprintf("Median household income: %s", dollar(select_postcode$income * 1000)), tags$br(),
      sprintf("Percent of adults with BA: %s%%", as.integer(select_postcode$school)), tags$br(),
      sprintf("Adult population: %s", select_postcode$adultpop)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = postcode)
  }

  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()

    isolate({
      showpostcodePopup(event$id, event$lat, event$lng)
    })
  })


  ## Data Explorer ###########################################

  observe({
    cities <- if (is.null(input$states)) character(0) else {
      filter(cleantable, State %in% input$states) %>%
        `$`('City') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$cities[input$cities %in% cities])
    updateSelectInput(session, "cities", choices = cities,
      selected = stillSelected)
  })

  observe({
    postcodes <- if (is.null(input$states)) character(0) else {
      cleantable %>%
        filter(State %in% input$states,
          is.null(input$cities) | City %in% input$cities) %>%
        `$`('postcode') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$postcodes[input$postcodes %in% postcodes])
    updateSelectInput(session, "postcodes", choices = postcodes,
      selected = stillSelected)
  })

  observe({
    if (is.null(input$goto))
      return()
    isolate({
      map <- leafletProxy("map")
      map %>% clearPopups()
      dist <- 0.01
      zip <- input$goto$zip
      lat <- input$goto$lat
      lng <- input$goto$lng
      showpostcodePopup(zip, lat, lng)
      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
    })
  })

  output$ziptable <- DT::renderDataTable({
    df <- cleantable %>%
      filter(
        Score >= input$minScore,
        Score <= input$maxScore,
        is.null(input$states) | State %in% input$states,
        is.null(input$cities) | City %in% input$cities,
        is.null(input$postcodes) | postcode %in% input$postcodes
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="',
                            Lat, '" data-long="', Long,
                            '" data-zip="', postcode,
                            '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    action <- DT::dataTableAjax(session, df)

    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })
}
