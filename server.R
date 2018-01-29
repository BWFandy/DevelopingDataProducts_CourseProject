#
# server.R

library(shiny)
library(dplyr)
library(ggplot2)
library(scales)

# Set Working Directory:
setwd("~/CourseraDataScienceSpecialty/9_Developing Data Products/RMEF_test")

# Load in data:
rmef <- read.csv("RMEF_test.csv")
head(rmef)


# Define server logic required to display elements of main panel:
shinyServer(function(input, output) {
        
        rmef_subset <- reactive({
                if(input$asgn == "All") {rmef}
                else {
                a <- subset(rmef, ASSIGNED == input$asgn)
                return(a)
                }
        })
        
        # Tab 1:
        output$plot1 <- renderPlot({
                minX <- input$sliderX[1]
                maxX <- input$sliderX[2]
                dataX <- rmef_subset()$MG_Score
                xlab <- "Score"
                main <- "Distribution of Scores in Selected Range"
          
                hist(dataX, xlim = range(minX:maxX), 
                     breaks = as.numeric(input$bins), 
                     xlab = xlab, main = main, ylim = c(0,input$ylim))
        })
        output$obs <- renderTable({
                format(nrow(subset(rmef_subset(), MG_Score>=input$sliderX[1] & MG_Score<=input$sliderX[2])), big.mark=",")
        }, colnames = FALSE)
        output$view1 <- renderPrint({
                summary(select(rmef, 2,6:7), digits = 2)
        })
        output$view2 <- renderPrint({
                dat <- subset(rmef_subset(), MG_Score>=input$sliderX[1] & MG_Score<=input$sliderX[2])
                summary(select(dat, 2,6:7), digits = 2)
        })
        
        # Tab 2: 
        brushedObs <- reactive({
                b <- brushedPoints(rmef_subset(), input$brush1, xvar="MG_Score", yvar="Engagement_Score")
        })
        output$plot2 <- renderPlot({
                minX <- input$sliderX[1]
                maxX <- input$sliderX[2]
                ggplot(rmef_subset(), aes(x=MG_Score, y=Engagement_Score, color=as.factor(ASSIGNED), size=Largest)) +
                        scale_color_manual(values = c("0"="#7F7F7F", "1"="#BE0F34")) +
                        coord_cartesian(xlim = range(minX:maxX)) +
                        geom_point(alpha=0.3) + 
                        geom_rug() +
                        labs(x="MG Score", y="Engagement Score", color="Assigned",
                             title="Scatterplot of Engagement & Modeling Scores") +
                        theme_light() +
                        theme(plot.title = element_text(hjust = 0.5))
        })
        output$brushedObs <- renderTable({
                if(is.null(brushedObs())){
                        "No Records Selected"
                } else {
                        format(nrow(brushedObs()), big.mark=",")
                }
        }, colnames = FALSE)
        output$view3 <- renderTable({
                brushSummary <- data.frame(v1 = min(brushedObs()$MG_Score), 
                                           v2 = max(brushedObs()$MG_Score),
                                           v3 = min(brushedObs()$Engagement_Score),
                                           v4 = max(brushedObs()$Engagement_Score),
                                           v5 = dollar(median(brushedObs()$Largest)),
                                           v6 = percent(sum(brushedObs()$ASSIGNED==1) / nrow(brushedObs())))
                colnames(brushSummary) <- c("Min. MG Score", "Max. MG Score", "Min. Eng. Score", "Max. Eng. Score",
                                            "Median Largest Gift", "Percent Assigned")
                if(is.null(brushedObs())){
                        "No Records Selected"
                } else {
                        brushSummary
                }
        })
})


