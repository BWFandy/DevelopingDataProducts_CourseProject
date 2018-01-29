#
# Set Working Directory:
setwd("~/CourseraDataScienceSpecialty/9_Developing Data Products/RMEF_test")

# Load in data:
rmef <- read.csv("RMEF_test.csv")
head(rmef)


# ui.R
library(shiny)

# Define UI for application that draws a histogram:
shinyUI(fluidPage(
  
  # Application title:
  titlePanel("RMEF - Example Shiny Charts"),
  
  # Sidebar panel layout:
  sidebarLayout(
    sidebarPanel(
            sliderInput("sliderX", "Choose the Range of Scores:",
                        0, 1000, value = c(0,1000)),
            selectInput("asgn", "Should Assigned be Included?",
                        choices = c("All"="All", "Assigned"=1, "Unassigned"=0)),
            selectInput("bins", "Level of Detail (bins):",
                        choices = c("Low"=50, "Medium"=100, "High"=200, "Very High"=500)),
            sliderInput("ylim", "Max Y-Axis:",
                        0, 500000, value = 250000)
                ),
    
    # Main panel contents:
    mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Tab 1", br(),
                                 # h2("Histogram of Scores", align = "center"),
                                 plotOutput("plot1"),
                                 h3("Count of Records Selected:"),
                                 tableOutput("obs"),
                                 h3("Baseline Summary Statistics"), h4("(all records):"),
                                 verbatimTextOutput("view1"),
                                 h3("Summary Statistics"), h4("(based on records selected):"),
                                 verbatimTextOutput("view2"),
                                 h3("Documentation"),
                                 h4("Example Prediction Scores on a 0-1,000 Scale"),
                                 p("This Shiny app allows users to explore the distribution of fictious predictive modeling scores. The classification probabilities from this model have been put in rank order and scored on a 0-1,000 scale."),
                                 h4("Tab 1:"),
                                 p("Users are able to select the desired range of scores to view, choose whether or not to include records that have been Assigned for special handling, modify the bin size, and adjust the Y-Axis of the histogram for easier reading."),
                                 p("Below the main histogram, users can view several reactive & static statistics that offer greater insight based on the selections they've made above."),
                                 p("NOTE: 'Largest' pertains to the largest purchase made by each record, 'Engagement_Score' refers to the numeric score representing each record's level of affiliation with our organization, and 'MG_Score' relates to the predictive modeling score described above.")
                        ),
                        tabPanel("Tab 2", br(),
                                 h2("Use Your Mouse to Highlight Specific Points for Further Analysis Below:"),
                                 plotOutput("plot2", brush = brushOpts(id = "brush1")),
                                 h3("Count of Records in Highlighted Boundary:"),
                                 tableOutput("brushedObs"),
                                 h3("Summary of Highlighted Records:"),
                                 tableOutput("view3"),
                                 h3("Documentation"),
                                 h4("Example Prediction Scores on a 0-1,000 Scale"),
                                 p("This Shiny app allows users to explore the distribution of fictious predictive modeling scores. The classification probabilities from this model have been put in rank order and scored on a 0-1,000 scale."),
                                 h4("Tab 2:"),
                                 p("This tab allows users to dynamically choose from a range of X- and Y-Axis values using their mouse. The same user-defined options are available on the left-side navigation pane."),
                                 p("Based on the user's selections in the scatterplot, the statistics below the scatterplot will reactively display the relevant values for further exploration.")
                        )
            )
    )
  )
))
