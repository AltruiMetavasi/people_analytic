# prepare environment
#--------------------

# load libs
library(DT)
library(magrittr)
library(plotly)
library(shinydashboard)
library(tidyverse)
library(tidyquant)

# import data
attrition <- readRDS("data_input/attrition.RDS")
predDataTemplate <- read_csv("data_input/predDataTemplate.csv")
predDataSample <- read_csv("data/Employee Batch 1.csv")

# import random forest model
rfMod <- readRDS("data_input/rfMod.RDS")

# start server
#--------------------

# initiate server
server <- shinyServer(function(input, output, session) {

  # initial state
  #--------------------

  # intiate reactives value
  reactives <- reactiveValues(

    predData = predDataSample,
    predDataName = "Employee Batch 1.csv",
    predDataNames = list.files("./data/"),
    DataTableRow = 1

  )

  # eda
  #--------------------

  #

  # pred
  #--------------------

  # render file upload UI
  output$predData <- renderUI({

    # input: file upload
    fileInput(
      label = h5("Upload .csv File:"),
      inputId = "predData",
      accept = ".csv")
  })

  # observe upload status
  observe({

    # check upload status
    status <- input$predData

    # if not null -> copy,
    if (is.null(status)) return(NULL)

    else if (!is.null(status)) {

      file.copy(
        status$datapath,
        file.path("./data_input/", status$name)
      )

      reactives$predDataNames <- list.files("./data_input/")

    }

  })

  # render available datasets UI
  output$predDataName <- renderUI({

    selectInput(
      label = h5("Select Dataset:"),
      inputId = "predDataName",
      choices = reactives$predDataNames,
      selected = reactives$predDataName
    )

  })

  observeEvent(input$predDataAB, {

    # update selected data
    if (!is.null(input$predDataName)) {

      reactives$predDataName <- input$predDataName

      reactives$predData <-
        paste0("data_input/", reactives$predDataName) %>%
        read_csv()

    }

  })

  observe({

    # readjust factor
    predData <- predDataTemplate %>%
      mutate(fromDB = TRUE) %>%
      bind_rows(
        reactives$predData %>%
          mutate(fromDB = FALSE)
      ) %>%
      mutate(
        Attrition = factor(Attrition, levels = c("Yes", "No")),
        Age = Age %>% as.numeric(),
        DailyRate = DailyRate %>% as.numeric(),
        DistanceFromHome = DistanceFromHome %>% as.numeric(),
        HourlyRate = HourlyRate %>% as.numeric(),
        MonthlyIncome = MonthlyIncome %>% as.numeric(),
        MonthlyRate = MonthlyRate %>% as.numeric(),
        NumCompaniesWorked = NumCompaniesWorked %>% as.numeric(),
        PercentSalaryHike = PercentSalaryHike %>% as.numeric(),
        TotalWorkingYears = TotalWorkingYears %>% as.numeric(),
        TrainingTimesLastYear = TrainingTimesLastYear %>% as.numeric(),
        YearsAtCompany = YearsAtCompany %>% as.numeric(),
        YearsInCurrentRole = YearsInCurrentRole %>% as.numeric(),
        YearsSinceLastPromotion = YearsSinceLastPromotion %>% as.numeric(),
        YearsWithCurrManager = YearsWithCurrManager %>% as.numeric()
      ) %>%
      mutate_if(is.character, as.factor) %>%
      mutate_if(is.integer, as.factor) %>%
      filter(fromDB == FALSE) %>%
      select(-fromDB)

    # predict
    reactives$attPred <- predData %>%
      mutate(Attrition = predict(rfMod, predData)) %>%
      bind_cols(predict(rfMod, predData, type = "prob"))

    # pred value box employe number
    reactives$nEmployee <- nrow(reactives$attPred)

    # pred attrition yes
    reactives$nAttritionY <- reactives$attPred %>%
      filter(Attrition == "Yes") %>%
      nrow()

    # pred attrition no
    reactives$nAttritionN <- reactives$attPred %>%
      filter(Attrition == "No") %>%
      nrow()

  })

  # render value box summary
  output$employeebox <- renderValueBox({

    valueBox(
      paste0(reactives$nEmployee), "Employee Number", icon = icon("users"),
      color = "purple"
    )

  })

  output$attritionbox <- renderValueBox({

    valueBox(
      paste0(reactives$nAttritionY),
      "Attrition", icon = icon("walking"), color = "yellow"
    )

  })

  output$stayingbox <- renderValueBox({

    valueBox(
      paste0(reactives$nAttritionN), "Employee Stay", icon = icon("users"),
      color = "purple"
    )

  })

  # render data table
  output$predtable <- renderDataTable(

    reactives$attPred,

    # data table options
    options = list(
      pageLength = 7,
      lengthMenu = 7,
      scrollX = TRUE
    ),

    selection = list(
      mode = 'single',
      selected = 1
    )

  )
  
  output$predpDownload <- downloadHandler(
    
    filename = function() {
      paste("PredictionResult.csv", sep = "")
    },
    
    content = function(file) {
      reactives$attPred %>%
       write_csv(rt(),file)
       
    }
    
  )

  observeEvent(input$predtable_rows_selected, {

    if (!is.null(input$predtable_rows_selected)) {

      reactives$DataTableRow <- input$predtable_rows_selected

    }

    reactives$EmployeeID <- reactives$attPred %>%
      slice(reactives$DataTableRow) %>%
      pull(EmployeeID)

    reactives$EmployeeAtt <- reactives$attPred %>%
      slice(reactives$DataTableRow) %>%
      pull(Attrition)

    if (reactives$EmployeeAtt == "Yes") {

      reactives$EmployeeAttProb <- reactives$attPred %>%
        slice(reactives$DataTableRow) %>%
        pull(Yes)

    } else {

      reactives$EmployeeAttProb <- reactives$attPred %>%
        slice(reactives$DataTableRow) %>%
        pull(No)

    }

  })

  output$employeIDbox <- renderValueBox({

    valueBox(
      paste0(reactives$EmployeeID), "Employee ID", icon = icon("users"),
      color = "purple"
    )

  })

  output$attritionYNbox <- renderValueBox({

    valueBox(
      paste0(reactives$EmployeeAtt),"Attrition", icon = icon("walking"),
      color = "yellow"
    )

  })

  output$probbox <- renderValueBox({

    valueBox(
      paste0(reactives$EmployeeAttProb), "Attrition Probability",
      icon = icon("users"),
      color = "purple"
    )

  })
  # end of server
  #--------------------
  
  # clear all uploaded file
  session$onSessionEnded(function() {
    
    file.remove(
      paste0("./data_input/", list.files("data_input") %>%
               .[. != "Employee Batch 1.csv"])
    )
    
  })
 
})
