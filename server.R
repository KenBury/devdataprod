library(shiny)
library(plyr)
library(caret)

# This sets up the classes and the initial ratio values for each class. 
dfclass_id = data.frame (class_id = c("AA", "AB", "AC", "BA", "BB", "BC"), ratio = c(2.5, 3.0, 1.5, 2.0, 4.0, 2.2))

shinyServer(function(input, output) {
        
        # This generates the main data set as the values are changed
        
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
                dfnode_id <- droplevels(dfnode_id[,c("node_id","class_id","ratio")])
                dfnode_id
        })
        
        # This generates the values that the kmeans is going to consider
        selectedData <- reactive({
                dfnode_id <- dfData()
                dfnode_id[, c("ratio", "ratio")]
        })
        
        # This captures predicted ratios for the classes
        ratiopoints <- reactive({
                dfnode_id <- dfData()
                modelFit <- train(ratio~class_id, data=dfnode_id, method="lm")
                dftest <- data.frame(class_id = levels(dfnode_id$class_id))
                pointsFit <- data.frame (ratio = predict(modelFit, dftest) , class_id = levels(dfnode_id$class_id))
                pointsFit
                
        })
        
        # This renders the data table
        output$dfnode_id <- renderDataTable({
                
                dfData()
                
        }, options=list(pageLength=10))
        
        
        # This renders the sample data with the fitted data points
        output$plot1 <- renderPlot({
                dfnode_id <- dfData()
                pointsFit <- ratiopoints()
                ## par(mar = c(5.1, 4.1, 0, 1))
                plot <- ggplot(dfnode_id, aes(class_id, ratio, color=class_id)) + geom_point(alpha = 1/2) 
                plot  + geom_point(data=pointsFit, aes(class_id, ratio), colour='black', size = 10, shape = 4,alpha = 1)
                
                     
                ## points(pointsFit$class_id, pointsFit$ratio, pch = 4, cex = 5, lwd = 4)
        })
        
        
})