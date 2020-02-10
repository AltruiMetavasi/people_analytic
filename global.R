# prepare environment -----------------------------------------------------

# import libs
library(DT)
library(lubridate)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(plotly)
library(shinythemes)


# import data
# attrition <- readRDS("data_input/attrition.RDS")
# predDataTemplate <- read_csv("data_input/predDataTemplate.csv")
# predDataSample <- read_csv("data/Employee Batch 1.csv")
# 
# # import random forest model
# rfMod <- readRDS("data_input/rfMod.RDS")

# import data
data_test <- read_csv("data_input/data-hr-test.csv")

# import model and recipe
hr_mod <- readRDS("data_input/model-hr.rds")
hr_rec <- readRDS("data_input/rec-hr.rds")


