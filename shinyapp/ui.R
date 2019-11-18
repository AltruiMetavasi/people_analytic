# prepare environment
#--------------------

# load libs
library(DT)
library(magrittr)
library(plotly)
library(shinydashboard)
library(tidyverse)
library(tidyquant)
library(shinythemes)

# header
#--------------------

# dashboard header
header <- dashboardHeader(

  # main title
  title = "Employee Attrition",

  titleWidth = 250

)

# sidebar
#--------------------

# introduction
introMenu <- menuItem(

  text = "Background",
  tabName = "intro",
  icon = icon("book-reader"),
  selected = TRUE

)

# prediction
predMenu <- menuItem(

  text = "Prediction",
  tabName = "pred",
  icon = icon("book-reader")

)

# full sidebar
sidebar <- dashboardSidebar(

  sidebarMenu(

    # intro
    introMenu,

    # pred
    predMenu

  ),

  width = 250

)

# body: intro - items
#--------------------
Backgroundtxt <- fluidPage(
  titlePanel("Attrition"),
    mainPanel( p("Attrition in very basic concept is type of employee churn. Some probably wonders what the diffrent with another type of churn 'the turnover', both are a decrease number of employees on staff, but attrition is typically voluntary or natural - like retirement or resignation. The problem is this could lead to relatively high cost to the company, the time or the cost of money from acquiring a new talent. In fact, the average cost-per-hire to fill a vacant position due to turnover or preventable attrition is $4,129."),
               br(),
               img(src = "data/Quits_rate_vs_unemployment_rate.png", height = 70, width = 200), 
               br(),
               p("In this project I try to predict employee attrition with machine learning. I will use a data set provide by IBM Sample Data. In his data, each variable (row) describes the employee with parameters like: age, department, Job Role, income, years at company, etc. The target variable 'Attrition' is known (it is historical value) and our main objective is to do machine learning classification (we predict yes/no for attrition)."),
    ))
              


# introduction text
introText <- box(

  # display html
  # includeHTML("demoday_attrition.html"),

  width = NULL

)


# body: intro - full
#--------------------

# data body
introBody <- tabItem(

  tabName = "intro",

  column(

    Backgroundtxt,

    width = 12

  )

)

# body: pred - input
#--------------------
predInputUI <- box(

    # input: file upload
    uiOutput(outputId = "predData"),

    # input: data settings
    uiOutput(outputId = "predDataName"),

    # input: decomposition action button
    actionButton(inputId = "predDataAB", label = "Apply"),

    status = "primary",
    width = NULL

)

# body: pred - output
#--------------------

# overall value box
ovpredboxUI <- box(

  # input employee Number Dynamic valueBoxes
  valueBoxOutput("employeebox"),

  # input attrition Number Dynamic valueBoxes
  valueBoxOutput("attritionbox"),

  # input stay employee Number Dynamic valueBoxes
  valueBoxOutput("stayingbox"),

  width = NULL

)

onepredboxUI <- box(

  # input employee ID Number Dynamic valueBoxes
  valueBoxOutput("employeIDbox"),

  # input Yes on no  employee Number Dynamic valueBoxes
  valueBoxOutput("attritionYNbox"),

  # input probability employee Dynamic valueBoxes
  valueBoxOutput("probbox"),

  width = NULL

)

predtableUI <- box(

  dataTableOutput(outputId = "predtable"),
  
  actionButton("predDownload", "Download Result"),

  width = NULL

)

# body: pred - full
#--------------------

# data body
predBody <- tabItem(

  tabName = "pred",

  fluidRow(

    column(

      predInputUI,

      width = 12

    )

  ),

  fluidRow(

    column(

      predtableUI,

      width = 5

    ),

    column(

      ovpredboxUI,

      onepredboxUI,

      width = 7

    )

  )

)

# body: full
#--------------------

# full body
body <- dashboardBody(
  
  # list of tabs
  tabItems(

    # intro
    introBody,

    # pred
    predBody

  )

)



# full UI
#--------------------

ui <- dashboardPage(
  # adding theme
  fluidPage(theme = shinytheme("journal"),

  # header
  header = header,

  # side bar
  sidebar = sidebar,

  # body
  body = body

)
