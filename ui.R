library(shiny)

shinyUI(fluidPage(
  titlePanel("Wine Guess Game"),
  h4('Imagine you hold a glass of a Loire Valley red wine, answer the questions on the left, 
     and the app will guess where it comes from (and show it) !'),
  sidebarLayout(
    sidebarPanel(
    h5('Questions'),
    p(em('values go from 0(low) to 10 (high)')),
    sliderInput('tannin', 'How much tannins do you see ?',value = 5, min = 0, max = 10, step = 0.005,),
    sliderInput('odor', 'How intense is the odor ?',value = 5, min = 0, max = 10, step = 0.005,),
    sliderInput('aroma', 'How intense are the aroma ?',value = 5, min = 0, max = 10, step = 0.005,),
    submitButton('Submit')
  ),
  mainPanel(
    verbatimTextOutput('aoc'),
    plotOutput('graph')
  )
))
)
