
  
  mcgun <- read.csv2("data/mcgun.csv2")
  library(ggplot2)
  library(dplyr)
  library(reshape2)
  location <- sort(c(state.abb, 'DC'))
  
  shinyServer(function(input, output) {
    
    output$state <- renderUI({
      selectInput(inputId = 'location',label = 'Choose a state:', choices = location, selected = location[1])
    })
  
    output$region <- renderUI({
      selectInput(inputId = "area", label =  "Choose a region:", choices =  c("Midwest", "Northeast",
                   "South Central", "South Atlantic", "West"), selected =  "Northeast")
    })
    
    output$multiplestates <- renderUI({
      selectizeInput('multiplestates', 'Choose up to 5 states to compare:', location, NULL, T,options = list(maxItems = 5, placeholder = 'Type a state abbreviation'))
      
    })
    
    output$barplot <- renderPlot({
      scale_mcgun <- mcgun %>% mutate(population = round(population/as.integer(input$pop)))
      scale_mcgun <- melt(scale_mcgun, id.vars = c('state', 'region'))
      scale_mcgun <- scale_mcgun %>% arrange(state, variable)
      
      if(is.null(input$data)==T){return()}
      bar_mcgun <- data.frame()
      for(i in 1:length(input$data)){bar_mcgun <- rbind(bar_mcgun, filter(scale_mcgun, variable == input$data[i]))}
  
      stateorregion <- reactive({ input$view })
      
      if( stateorregion() == 'regions' ){
        area <- reactive({ input$area })
        ismatch <- bar_mcgun[,2] == area()
        bar_mcgun <-  bar_mcgun[ismatch,]
  
      }
      
      if( stateorregion() == 'states' ){ 
        location <- reactive({ input$location })
        ismatch <- bar_mcgun[,1] == location()
        bar_mcgun <- bar_mcgun[ismatch,]
        
      }
      
      if( stateorregion() == 'compare'){
        manystates <- reactive({ input$multiplestates })
        temp_df <- data.frame()
        for(i in 1:length(manystates())){ temp_df <- rbind(temp_df, bar_mcgun[(bar_mcgun[,1]==manystates()[i]),])}
        bar_mcgun <- temp_df
      }
      
      ggplot(bar_mcgun, aes(state, value, fill = as.factor(variable))) +
        geom_bar(stat = 'identity', position = 'dodge')
      
    })
    
  })