library(shiny)
library(plyr)

dfclass_id = data.frame (class_id = c("AA", "AB", "AC", "BA", "BB", "BC"), ratio = c(2.5, 3.0, 1.5, 2.0, 4.0, 2.2))
shinyServer(function(input, output) {
        
        # Expression that generates a histogram. The expression is
        # wrapped in a call to renderPlot to indicate that:
        #
        #  1) It is "reactive" and therefore should re-execute automatically
        #     when inputs change
        #  2) Its output type is a plot
        
        dfData <- reactive({
                dfnode_id <- data.frame (node_id = paste0 (sample(LETTERS[1:10], replace = TRUE), seq(1:input$no_node)),
                                         class_id = sample(sample(dfclass_id$class_id, size = input$no_class), size = input$no_node, replace = TRUE))
                dfnode_id <- join(dfnode_id, dfclass_id, by='class_id', type='left', match='all')
                colnames(dfnode_id)[which(colnames(dfnode_id) == 'ratio')] <- 'sample1'
                dfnode_id <- join(dfnode_id, dfclass_id, by='class_id', type='left', match='all')
                colnames(dfnode_id)[which(colnames(dfnode_id) == 'ratio')] <- 'sample2'
                dfnode_id <- join(dfnode_id, dfclass_id, by='class_id', type='left', match='all')
                colnames(dfnode_id)[which(colnames(dfnode_id) == 'ratio')] <- 'sample3'
                dfnode_id$sample1 <- with( dfnode_id , jitter(sample1) )
                dfnode_id$sample2 <- with( dfnode_id , jitter(sample2) )
                dfnode_id$sample3 <- with( dfnode_id , jitter(sample3) )
                dfnode_id$ratio <- with( dfnode_id , (sample1+sample2+sample3)/3.00 )
                dfnode_id
        })
        
        selectedData <- reactive({
                dfnode_id <- dfData()
                dfnode_id[, c("ratio", "ratio")]
        })
        
        clusters <- reactive({
                kmeans(selectedData(), input$no_class)
        })
        
        output$dfnode_id <- renderDataTable({
                
                dfData()
                
        }, options=list(pageLength=10))
        
        
        
        
        
        output$plot1 <- renderPlot({
                par(mar = c(5.1, 4.1, 0, 1))
                plot(selectedData(),
                     col = clusters()$cluster,
                     pch = 20, cex = 3)
                points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
        })
        
        
})