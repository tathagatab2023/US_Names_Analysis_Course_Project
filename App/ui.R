dashboardPage(
  dashboardHeader(title = "Name Popularity Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard",
               tabName = "Home",
               icon = icon("house-chimney")),
      menuItem("Rank Table",
               tabName = "top_ranked_names",
               icon = icon("table")),
      menuItem("Initial Letter Analysis",
               tabName = "initial_letter_analysis",
               icon = icon("a")),
      menuItem("Total Number vs Rank Analysis",
               tabName = "number_of_babies_top_rank",
               icon = icon("chart-simple")),
      menuItem("Name Specific Analysis",
               tabName = "popularity_of_names",
               icon = icon("user"))
    )
  ),
  dashboardBody(
    use_theme(my_theme),
    style = "padding: 0px",
    style = "height: 93.7vh; padding: 0px; background-size: cover; background-image: url(https://res.cloudinary.com/df2guklk2/image/upload/v1699873793/k69hxcjs7vn1vqoqmey7.jpg)",
    tabItems(
      tabItem(
        # Tab styling
        tabName = "Home",
        
        div(
          style = "width: 100%; height: 93.7vh; background-image: url(https://res.cloudinary.com/df2guklk2/image/upload/v1699892872/kapmdyemcxjowabnf7kt.png); background-size: cover; text-align: center; padding: 0px;",
          id = "home",
          div(
            style = "width: 100%; height: 55%; background-image: url(https://res.cloudinary.com/df2guklk2/image/upload/v1699892872/kapmdyemcxjowabnf7kt.png); background-size: cover; display: flex; align-items: center; justify-content: center; text-align: center; vertical-align: center; padding: 5px;",
            div(
              style = "margin-top: -60px",
              p(
                style = "color: #FF8FA4; font-size: 50px; font-family: 'Lato', sans-serif; text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.7);",
                strong("Popularity Analysis of Baby Names in USA")
              ),
              p(
                style = "font-size: 18px; font-family: 'Roboto', sans-serif; color: white; text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);",
                "We will use the app to analyze the given dataset of the most popular baby names in the US"
              )
            )
          ),
          div(
            style = "padding: 30px; padding-top: 5px; margin: 40px; margin-top: -120px; border-radius: 30px; box-shadow: -3px -8px 8px rgba(0, 0, 0, 0.2); background-color: #FF8FA4;",
            div(
              style = "text-align: left; font-size: 16px",
              h2(
                style = "margin-bottom: 20px; font-family: 'Lato', sans-serif; color: white; text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5); ",
                strong("The App Consists of Four Panels :-")
              ),
              div(
                style = "background-color: #FFDCE2; padding: 10px; border-radius: 8px; margin-bottom: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1)",
                p("1. The first panel is 'Rank Table' which showcases Top N popular names from a specific decade where the Decade and N are user inputs")
              ),
              div(
                style = "background-color: #FFDCE2; padding: 10px; border-radius: 8px; margin-bottom: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1)",
                p("2. The second panel is 'Initial Names Analysis' which plots the total number of names starting with 1 or multiple letters of males and females where the letters are user inputs")
              ),
              div(
                style = "background-color: #FFDCE2; padding: 10px; border-radius: 8px; margin-bottom: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1)",
                p("3. The third panel is 'Total Number of Baby names at Top Ranks' which plots the number of babies corresponding to the top x ranks in a certain decade for both males and females on the same graph")
              ),
              div(
                style = "background-color: #FFDCE2; padding: 10px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1)",
                p("4. The fourth panel is 'Name Specific Analysis' which plots the number of babies and ranks along decades of a name entered as user input")
              )
            )
          )
        )
      ),
      tabItem(
        # Tab styling
        style = "height: 93.7vh; padding: 20px;",
        tabName = "top_ranked_names",
        
        div(
          # Container styling
          style = "height: 93.7vh",
          
          fluidRow(
            # Information box
            div(style = "margin-left : 20px ; margin-top : -20px ; margin-bottom : 15px ",
                h1(strong("Rank Table")),
            )),
          
          fluidRow(
            
            # Table display and input controls
            box(DTOutput("tableTopRankedName")),
            tabBox(title = HTML("Control Panel<br>"),
                   tabPanel(strong("Configurator"),
                            h4("This panel shows a table of Top Ranked Names from the selected decade.\n "),
                            h5("Selecting any name from the table will show its past performance in Anaytics Tab"),
                            p("Change the decade and Number Name to display"),
                            selectInput(
                              "selectedDecade",
                              "Select Decade:",
                              choices = seq(1920, 2010, by = 10),
                              selected = c(1920, 2010)
                            ),
                            numericInput(
                              "selectedno",
                              "Enter number of names to be displayed:",
                              value = 10,
                              min = 1,
                              max = 100
                            )),
                   tabPanel(strong("Analytics"),girafeOutput("linePlot2"))
            )
          )
        )
      ),
      tabItem(
        # Tab styling
        style = "height: 93.7vh; padding: 20px;",
        tabName = "initial_letter_analysis",
        
        fluidRow(
          # Information box
          div(style = "margin-left : 20px ; margin-top : -20px ; margin-bottom : 15px ",
              h1(strong("Initial Letter Analysis")),
          )
        ),
        
        fluidRow(
          # Graph and input controls
          box(
            style = "text-align: center",
            h4(strong("Total number of Names vs Initial Letter")),
            plotOutput("barPlot_initial_letter"),
            h4(strong("Total number of Names vs Last Letter")),
            plotOutput("barPlot_last_letter")
          ),
          box(
            h4("This panel displays two plots\n 
               1. Total numbers of Names vs Initial Letter\n
               2. Total numbers of Names vs Last Letter"),
            h5("Choose either one letter or multiple letters and display them simultaneously on the same graph."),
            selectInput(
              "LetterSelector1",
              "Choose Multiple Letters - Initail Letter Analysis",
              choices = letter.choices,
              multiple = TRUE,
              selected = c(LETTERS)
            )
          )
        )
      ),
      tabItem(
        # Tab styling
        style = "height: 93.7vh; padding: 20px;",
        tabName = "number_of_babies_top_rank",
        
        fluidRow(
          # Title
          width = 12,
          div(style = "margin-left : 20px ; margin-top : -20px ; margin-bottom : 15px ",
              h1(strong("Total Number vs Rank Analysis")),
          )
        ),
        
        fluidRow(
          # Line plot and input controls
          box(
            plotOutput("lineplot2")
          ),
          box(  
            h4("This panel displays a plot of Total numbers of Names vs Rank"),
            h5("Choose the decade and number of name to plot"),
            selectInput(
              "selectedDecadeForGraph",
              "Select Decade:",
              choices = seq(1920, 2010, by = 10),
              selected = 2000
            ),
            numericInput(
              "selectedNamesForGraph",
              "Enter number of top names to display:",
              value = 100,
              min = 1,
              max = 100
            )
          )
        )
      ),
      tabItem(
        # Tab styling
        style = "height: 93.7vh; padding: 20px;",
        tabName = "popularity_of_names",
        
        fluidRow(
          # Information box
          div(style = "margin-left : 20px ; margin-top : -20px ; margin-bottom : 15px ",
              h1(strong("Name Specific Analysis")),
          )
        ),
        
        fluidRow(
          # Line graph and input controls
          box(
            style = "text-align: center",
            h4(strong("Rank vs Decade (Name Specific)")),
            girafeOutput("linePlot"),
          ),
          box(
            h4("This panel plots the a line graph of Rank vs Decade of a specific name that ever made it to the Top 100 list in any decade"),
            h5("Selected any name to display it performance"),
            selectInput("NameSelector1", "Choose a Name", choices = name.choices),
            h2("Meaning and History"),
            textOutput("details")
          )
        )
      )
    )
  )
  
)