#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Trimmed k-means"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        
        sidebarPanel(
            h4("tkmeans in tclust-package"),
            # # Ideally, I'd have a few datasets to choose from:
            selectInput(inputId = "dataSet",
                        label = "Choose Data Set:",
                        choices =  c("Ruspini" = "ruspini",
                                     "xClara" = "xclara",
                                     #"Iris" = "iris",
                                     "Gaussian" = "gauss",
                                     "Uniform" = "unif",
                                     "One Circle" = "oneCircle",
                                     "Two Circles" = "twoCircles",
                                     "Bullseye" = "bullseye"),
                        selected = "ruspini"),
            numericInput(inputId = "numCluster", 
                        label = "Number of clusters",
                        value = 4, min = 1, max = 12,
                        step = 1),
            sliderInput(inputId = "alpha", 
                        label = "Value of alpha",
                        value = 0.05, min = 0, max = 1,
                        step = 0.01),
            checkboxInput(inputId = "showCenter", 
                          label = "Show resulting cluster centers", 
                          value = TRUE)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h2("Baldvin Einarsson, PhD"),
            h2("Visualization"),
            helpText(a("See github page for details on code",
                       href = "https://github.com/baldvine/trimmedKmeans",
                       target = "_blank")
            ),
            plotOutput("kMeansPlot")
        )
        
    )
))
