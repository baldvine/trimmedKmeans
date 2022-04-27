#
#

library(shiny)
library(ggplot2)
library(cluster)
library(flexclust)
library(magrittr)
# library(Rcpp)
# library(RcppArmadillo)
library(tclust)
library(RColorBrewer)


shinyServer(function(input, output) {
    
    
    # Choose dataset:
    data2use <- reactive({
        if (input$dataSet == "ruspini") {
            return(ruspini)
        }
        if (input$dataSet == "xclara") {
            myData <- xclara
            names(myData) <- c("x","y")
            return(myData)
        }
        if (input$dataSet == "unif") {
            return(data.frame(x = runif(1000), y = runif(1000)))
        }
        if (input$dataSet == "gauss") {
            return(data.frame(x = rnorm(1000), y = rnorm(1000)))
        }
        if (input$dataSet == "oneCircle") {
            rad <- 2*pi*runif(250)
            len <- rnorm(250, mean = sqrt(2), sd = 0.01)
            return(data.frame(x = len*cos(rad), y = len*sin(rad)))
        }
        if (input$dataSet == "twoCircles") {
            outerRad <- 2*pi*runif(350)
            outerLen <- rnorm(350, mean = sqrt(2), sd = 0.02)
            innerRad <- 2*pi*runif(200)
            innerLen <- rnorm(200, mean = 1, sd = 0.01)
            return(data.frame(x = c(outerLen*cos(outerRad),innerLen*cos(innerRad)), 
                              y = c(outerLen*sin(outerRad),innerLen*sin(innerRad)))
            )
        }
        if (input$dataSet == "bullseye") {
            rad <- 2*pi*runif(250)
            len <- rnorm(250, mean = sqrt(2), sd = 0.01)
            return(data.frame(x = c(len*cos(rad),rnorm(300, sd = 0.2)), 
                              y = c(len*sin(rad),rnorm(300, sd = 0.2)))
            )
        }
        })
    
    plotAlpha <- reactive({
        if (input$dataSet == "xclara") {
            return(0.2)
        }
        else {
            return(0.5)
        }
    })
    
    # Get number of clusters:
    numClusters <- reactive({input$numCluster})
    # Get value of alpha:
    myAlpha <- reactive({input$alpha})
    
    kMeansSolution <- reactive({
        return(tclust::tkmeans(x = data2use(), k = numClusters(),
                               nstart = 25, alpha = myAlpha(),
                               drop.empty.clust = FALSE, 
                               warnings = FALSE))            
    })
    
    output$kMeansPlot <- renderPlot({
        
        showResultCenters <- input$showCenter
        myDF <- cbind(rbind(data2use(),t(kMeansSolution()$centers)),
                      cluster = factor(c(kMeansSolution()$cluster,1:numClusters()),
                                       levels = 0:numClusters(),
                                       labels = c("Outlier", 1:numClusters())),
                      Type = factor(c(rep("Data",nrow(data2use())),
                                      rep("Centers",numClusters())), 
                                      levels = c("Data", "Centers"))
                                    
                      )
        if (!showResultCenters) {
            myDF <- myDF[!grepl("Centers", myDF$Type),]
        }
        
        myPlot <- 
            ggplot(data = myDF, aes(x,y, color = cluster, shape = Type, size = Type, alpha = Type)) +
            geom_point() +
            #scale_color_manual(values = c("red", brewer.pal(8, "Dark2"))) +
            scale_color_manual(values = c("red", 
                ggthemes::tableau_color_pal(palette = "Classic Green-Orange 12")(12))) +
            #scale_color_brewer(palette = "Set1") + 
            scale_alpha_manual(values = c(plotAlpha(), 1), guide = "none") +
            scale_shape_manual(values = c(16,75)) +
            scale_size_manual(values = c(4,7), guide = "none") +
            guides(color = guide_legend(title = "Cluster", 
                                        override.aes = list(size=4, alpha = 1), 
                                        order = 2),
                   shape = guide_legend(title = "Type", order = 1,
                                        override.aes = list(size=3, alpha = 1))) +
            theme(plot.title = element_text(hjust = 0.5),
                  legend.title = element_text(size = 16), 
                  legend.text = element_text(size = 14),
                  legend.box.background = element_rect(fill = NA, color = "black"),
                  legend.background = element_blank(),
                  legend.key = element_blank(),
                  axis.title = element_text(size = 20),
                  axis.text = element_blank(),
                  axis.ticks = element_blank(),
                  panel.background = element_rect(fill = "white", colour = NA), 
                  panel.border = element_rect(fill = NA, colour = "grey20")) +
            coord_equal()
        
        if (showResultCenters) {  
            # Shows up as black. If removed, they get colored according to the cluster
            myPlot <- myPlot +
                geom_point(data = myDF[grepl("Centers", myDF$Type),], 
                           inherit.aes = FALSE, aes(x,y),
                           size = 5, show.legend = FALSE, color = "black", shape = "K")
        }
        
        #        generate bins based on input$bins from ui.R
        # x    <- faithful[, 2] 
        # bins <- seq(min(x), max(x), length.out = input$numCluster + 1)
        # 
        # # 
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')

        if (input$dataSet %in% c("oneCircle","twoCircles", "bullseye")) {
            myPlot <- myPlot + coord_equal()
        }
        
        return(myPlot)        
    })
    
})

