library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Approaching a Normal Distribution with Dice Rolls"),
    
    sidebarPanel(
        sliderInput('groupingSize', 'How many dice we roll', value = 1, min = 1, max = 25, step = 1),
        sliderInput('samples', 'How many times we roll the dice', value = 100, min = 1, max = 500, step = 1),
        numericInput('maxValue', 'Number of sides on one die', value = 6, min = 2, max = 10, step = 1)
    ),
    
    mainPanel(
        p('The histogram below shows how the distribution of die roll means approaches normal as you add dice and roll more often.'),

        h3('Instructions:'),
        p('Select any of the following, and watch the plot change:'),
        HTML(paste('<ul>',
            '<li>How many dice to roll;</li>',
            '<li>How many times we roll the dice; or,</li>',
            '<li>The number of sides on each die.</li>',
            '</ul>', sep = ' ')),
        p('The plot will update automatically to the values you select.'),
        
        plotOutput('hist')
    )
))
