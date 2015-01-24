library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Clustering Simulation"),
        
        sidebarLayout(
                sidebarPanel(
                 
                       sliderInput('no_class', 'Number of Classes:', 
                                   min=1, max=5, value = 3),
                       
                       sliderInput('no_node', 'Number of Nodes:', 
                                   min=10, max=100, value = 50),
                       
                       helpText("Note: This application generates simulated data similar to what is expected from the field.",
                                "Adjust the number of classes and nodes",
                                "using the sliders. The data and plot output",
                                "are selected using the tabs. It is expected that the clusters should be identified by the 'X's on the graph")
                                       
                ),
                                             
                       # Show a table summarizing the values generated
                mainPanel(
                        tabsetPanel(type = "tabs", 
                                    tabPanel("Data", dataTableOutput({ 'dfnode_id' })),
                                    tabPanel("Plot", plotOutput({ 'plot1' }))
                                )
                        )
                )
        )
)