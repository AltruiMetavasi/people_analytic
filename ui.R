#--------------------
# header

# dashboard header
header <- dashboardHeader(
  # main title
  title = "withPeeps",
  titleWidth = 250
)

#--------------------
# sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    # Background
    menuItem(
      text = "Background",
      tabName = "Background",
      icon = icon("book-reader")
    ),
    # Overview
    menuItem(
      text = "Overview",
      tabName = "Overview",
      icon = icon("book-reader")
    )
  ),
  width = 250
)

# body Background - full
#--------------------

# data body
BackgroundBody <- tabItem(
  tabName = "Background",
  column(
    Background,
    width = 12)
  )

# body: or - input
#--------------------
dataInputUI <- box(
    # input: file upload
    uiOutput(outputId = "predata"),
    # input: data settings
    uiOutput(outputId = "predata"),
    # input: decomposition action button
    actionButton(inputId = "predata", label = "Apply"),
    status = "primary",
    width = NULL
)

# body: or - output
#--------------------
tableUI <- box(
  dataTableOutput(outputId = "ortable"),
  actionButton("ordownload", "Download Result"),
  width = NULL
)

# body: or - full
#--------------------
# data body
overbody <- tabItem(
  tabName = "Overview",
  fluidRow(
    # input employee Number Dynamic valueBoxes
    valueBoxOutput(
      inputId = "employee_box",
      "—", "Total Employee",
      color = "purple",
      icon = icon("comment-dots"),
      width = 3),
    # input attrition Number Dynamic valueBoxes
    valueBoxOutput(
      inputId = "attrition_box",
      "—", "Total Churn Employee",
      color = "orange",
      icon = icon("user-circle"),
      width = 3),
    # input stay employee Number Dynamic valueBoxes
    valueBoxOutput(
      inputId = "staying_box",
      "—", "Total Stayed Employee",
      color = "green",
      icon = icon("hourglass-half"),
      width = 3),
    # input employee ID Number Dynamic valueBoxes
    valueBoxOutput(
      inputId = "employeID_box",
      "—", ("Employee ID"),
      color = "red",
      icon = icon("heart"),
      width = 3),
    # input Yes on no  employee Number Dynamic valueBoxes
    valueBoxOutput(
      inputId = "attritionYNbox",
      "—", ("Attrittion Y/N"),
      color = "teal",
      icon = icon("map-signs"),
      width = 3),
    # input probability employee Dynamic valueBoxes
    valueBoxOutput("probbox"),
      "—", ("Attrittion Probability"),
      color = "teal",
      icon = icon("percent"),
      width = 3),
  fluidRow(
    column(
      ortableUI,
      width = 12
      ),
    )
  )

# body: full
#--------------------
# full body
body <- dashboardBody(
  # list of tabs
  tabItems(
    # intro
    BackgroundBody,
    # overview
    overbody
  )
)

# full UI
#--------------------

ui <- dashboardPage(
  # adding theme
  fluidPage(
    theme = shinytheme("journal"),
    header = header, # header
    sidebar = sidebar, # side bar
    body = body, # body
    theme = shinytheme("cosmo")
  )
)