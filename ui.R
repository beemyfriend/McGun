shinyUI(fluidPage(
  titlePanel("McGun"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Look at number of Gundealers, McDonald's, Hospitals, and/or Population of states either individually or by region:"),
      
      radioButtons('view', 'View U.S.A data according to state, region, or compare multiple states:', c('states', 'regions', 'compare'), 'regions'),
      
      conditionalPanel(
        "input.view == 'states'",
        uiOutput('state')
      ),
      
      conditionalPanel(
        "input.view == 'regions'",
        uiOutput('region')
      ),
      
      conditionalPanel(
        "input.view == 'compare'",
        uiOutput('multiplestates')
      ),
      
      checkboxGroupInput("data", 
                  label = "Data of interest:",
                  c( 'population','gundealers', "mcdonalds", 'hospitals'),
                  c( 'population','gundealers', "mcdonalds", 'hospitals')),
      
      selectInput('pop', 'Population by:', c('1000', '10000', '100000'), '10000')
      
      ),

    mainPanel(
      plotOutput('barplot')
    )
  )
))