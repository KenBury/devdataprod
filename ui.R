library(shiny)

# Define UI for application that provides value selection and output tabs
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Class predicting ratio parameter"),
        
        sidebarLayout(
                sidebarPanel(
                 
                       sliderInput('no_class', 'Number of Classes:', 
                                   min=2, max=6, value = 4),
                       
                       sliderInput('no_node', 'Number of Nodes:', 
                                   min=10, max=100, value = 50),
                       
                       helpText("Note: This application generates simulated data similar to what is expected from the field.",
                                "Adjust the number of classes and nodes",
                                "using the sliders. The data and plot output",
                                "are selected using the tabs. The data plot shows the simulated data and the predicted ratios are identified by the 'X's on the graph",
                                "This is a part of the assignment for the Coursera - John Hopkins - Developing Data Products course.",
                                "Prepared by Ken Bury, 01/25/2015.")                    
                ),   
                      
                mainPanel(
                        tabsetPanel(type = "tabs", 
                                    # Show a table summarizing the values generated
                                    tabPanel("Data", dataTableOutput({ 'dfnode_id' })),
                                    
                                    # Show a plot of the sample data with the fitted class ratio points
                                    tabPanel("Plot", plotOutput({ 'plot1' }))
                                )
                        )
                )
        )
)