function(input, output, session) {
  
  
  
  ### Top Names Decadewise (Top Ranked Names)
  DataTopRank <- reactive({
    req(input$selectedDecade)
    req(input$selectedno)
    
    selected_data <- subset(baby_names, Decade == input$selectedDecade)
    
    if ("Male.Name" %in% colnames(selected_data) && "Female.Name" %in% colnames(selected_data)) {
      
      RankLen <- input$selectedno
      if (RankLen > 100) {RankLen <- 100}
      top_male_names <- head(selected_data$`Male.Name`, RankLen)
      top_female_names <- head(selected_data$`Female.Name`, RankLen)
      data.frame("Male_Names" = top_male_names, "Female_Names" = top_female_names)
      
    } else {
      h3("Error: 'Male Name' or 'Female Name' columns not found in the selected dataset.")
    }
  })
  
  
  
  # Create a dynamic main panel with a table
  output$tableTopRankedName <- renderDT(DataTopRank(), selection = list(mode = "single", target = "cell"))
  
  
  ###Analytics Plot
  observeEvent(input$tableTopRankedName_cell_clicked, { 
    name <- input$tableTopRankedName_cell_clicked
    print(name$value[[1]])
    if (!is.null(name$value))  {
      graphData <- filter(common, Name == name$value[[1]])
      output$linePlot2 <- renderGirafe({
        GenderColor <- c("#3498db", "#ff69b4")
        BoyColor <- "#3498db"
        GirlColor <- "#ff69b4"
        PopularityPlot <- ggplot() +
          geom_line_interactive(data = filter(graphData, Gender == "Male"), aes(x = Decade, y = Rank), size = 1, colour = BoyColor) +
          geom_point_interactive(data = filter(graphData, Gender == "Male"), aes(x = Decade, y = Rank, tooltip = paste0("Decade - ", Decade, "\nRank - ", Rank, "\nTotal Number of Births - ", Births), data_id = Decade), size = 2, colour = BoyColor) +
          geom_line_interactive(data = filter(graphData, Gender == "Female"), aes(x = Decade, y = Rank), size = 1, colour = GirlColor) +
          geom_point_interactive(data = filter(graphData, Gender == "Female"), aes(x = Decade, y = Rank, tooltip = paste0("Decade - ", Decade, "\nRank - ", Rank, "\nTotal Number of Births - ", Births), data_id = Decade), size = 2, colour = GirlColor) +
          xlim(1910, 2010) +
          ylim(101, 0)
        
        girafe_options(girafe(ggobj = PopularityPlot), opts_tooltip(
          css = NULL,
          offx = 12,
          offy = 10,
          use_cursor_pos = TRUE,
          opacity = 0.7,
          use_fill = FALSE,
          use_stroke = FALSE,
          delay_mouseover = 200,
          delay_mouseout = 500,
          placement = c("auto", "doc", "container"),
          zindex = 999
        ))
      })
    }
  })
  
  
  
  
  
  ### Initial Letter Analysis (Baby Names by First Letter function)
  
  
  # (Baby Names by Letter) Required Data, Variables and Logic
  
  f.unique.let <- unique(as.vector(female$Name))
  m.unique.let <- unique(as.vector(male$Name))
  c.unique.let <- sort(append(m.unique.let, f.unique.let))
  
  no.unique.initial <- data.frame(Letter <- NULL, Gender <- NULL, Total <- NULL)
  for (i in 1:26) {
    Letter <- LETTERS[i]
    Gender <- "Male"
    Total <- length(m.unique.let[startsWith(toupper(m.unique.let), LETTERS[i])])
    new.row <- data.frame(Letter, Gender, Total)
    no.unique.initial <- rbind(no.unique.initial, new.row)
    Gender <- "Female"
    Total <- length(f.unique.let[startsWith(toupper(f.unique.let), LETTERS[i])])
    new.row <- data.frame(Letter, Gender, Total)
    no.unique.initial <- rbind(no.unique.initial, new.row)
  }
  
  no.unique.last <- data.frame(Letter <- NULL, Gender <- NULL, Total <- NULL)
  for (i in 1:26) {
    Letter <- LETTERS[i]
    Gender <- "Male"
    Total <- length(m.unique.let[endsWith(toupper(m.unique.let), LETTERS[i])])
    new.row <- data.frame(Letter, Gender, Total)
    no.unique.last <- rbind(no.unique.last, new.row)
    Gender <- "Female"
    Total <- length(f.unique.let[endsWith(toupper(f.unique.let), LETTERS[i])])
    new.row <- data.frame(Letter, Gender, Total)
    no.unique.last <- rbind(no.unique.last, new.row)
  }
  
  # Reactive Part (Selector)
  
  DataInitial <- reactive({
    req(input$LetterSelector1)
    letter <- as.character(input$LetterSelector1)
    print(letter)
    df <- data.frame(Letter <- NULL, Gender <- NULL, Total <- NULL)
    for (i in 1:length(letter)) {
      df <- rbind(df, filter(no.unique.initial, Letter == letter[i]))
    }
    df
  })
  
  DataLast <- reactive({
    req(input$LetterSelector1)
    letter <- as.character(input$LetterSelector1)
    print(letter)
    df <- data.frame(Letter <- NULL, Gender <- NULL, Total <- NULL)
    for (i in 1:length(letter)) {
      df <- rbind(df, filter(no.unique.last, Letter == letter[i]))
    }
    df
  })
  
  
  # Bar Plot of Total No. of Unique Names
  
  output$barPlot_initial_letter <- renderPlot({
    ggplot(DataInitial(), aes(x = Letter, y = Total, fill = Gender)) +
      geom_bar(stat = "identity", position = "dodge") +
      xlab("Letters") +
      ylab("Total Number of Names (in Millions)")
  })
  
  
  output$barPlot_last_letter <- renderPlot({
    ggplot(DataLast(), aes(x = Letter, y = Total, fill = Gender)) +
      geom_bar(stat = "identity", position = "dodge") +
      xlab("Letters") +
      ylab("Total Number of Names (in Millions)")
  })
  
  
  
  
  # Number of babies at every Rank
  
  # Create a line plot for the number of babies with ranks 1 to X
  output$lineplot2 <- renderPlot({
    
    selected_data <- subset(baby_names, Decade == input$selectedDecadeForGraph)
    top_male_names <- head(selected_data$`Male.Name`, input$selectedNamesForGraph)
    top_female_names <- head(selected_data$`Female.Name`, input$selectedNamesForGraph)
    
    babies_with_ranks_female <- selected_data$`No..of.births.F.`[selected_data$`Female.Name` %in% top_female_names]
    babies_with_ranks_male <- selected_data$`No..of.births.M.`[selected_data$`Male.Name` %in% top_male_names]
    
    plot(1:input$selectedNamesForGraph, babies_with_ranks_male, type = "l", col = "blue",
         xlab = "Rank", ylab = "Number of Babies",
         main = paste("Number of Babies with Top", input$selectedNamesForGraph, "Ranked Names"),
         xlim = c(1, input$selectedNamesForGraph), ylim = c(0, max(babies_with_ranks_male, babies_with_ranks_female)))
    
    lines(1:input$selectedNamesForGraph, babies_with_ranks_female, col = "red")
    legend("topright", legend = c("Male", "Female"), col = c("blue", "red"), lty = 1)
    
    x_values <- seq(1, input$selectedNamesForGraph, by = max(1, round(input$selectedNamesForGraph / 10))) # Adjust the divisor for desired spacing
    axis(1, at = x_values, labels = x_values)
  })
  
  
  
  
  # Popularity of names Graph
  
  p <- function(name) {
    
    tmpMaleRank <- integer(10)
    tmpMaleBirth <- integer(10)
    tmpMaleRatio <- integer(10)
    tmpFemaleRank <- integer(10)
    tmpFemaleBirth <- integer(10)
    tmpFemaleRatio <- integer(10)
    tmpDecade <- seq(1920, 2010, 10)
    
    if (dim(filter(common, Name == name, Gender == "Male"))[[1]] > 0) {
      for (i in 1:10) {
        tmp <- filter(common, Name == name, Gender == "Male", Decade == tmpDecade[i])
        if (dim(tmp)[[1]] > 0) {
          tmpMaleBirth[i] <- tmp$Births
          tmpMaleRank[i] <- tmp$Rank
          tmpMaleRatio[i] <- tmp$Popularity.Ratio
        } else {
          tmpMaleBirth[i] <- "NA"
          tmpMaleRank[i] <- 101
          tmpMaleRatio[i] <- "NA"
        }
      }
      df.male <- data.frame(Decade = tmpDecade ,Name = replicate(10, name)  , Gender = replicate(10, "Male"), Births = tmpMaleBirth , Rank = tmpMaleRank , Popularity.Ratio = tmpMaleRatio)
    } else {df.male = NULL}
    
    if (dim(filter(common, Name == name, Gender == "Female"))[[1]] > 0) {
      for (i in 1:10) {
        tmp <- filter(common, Name == name, Gender == "Female", Decade == tmpDecade[i])
        if (dim(tmp)[[1]] > 0) {
          tmpFemaleBirth[i] <- tmp$Births
          tmpFemaleRank[i] <- tmp$Rank
          tmpFemaleRatio[i] <- tmp$Popularity.Ratio
        } else {
          tmpFemaleBirth[i] <- "NA"
          tmpFemaleRank[i] <- 101
          tmpFemaleRatio[i] <- "NA"
        }
      }
      df.female <- data.frame(Decade = tmpDecade ,Name = replicate(10, name) , Gender = replicate(10, "Female"), Births = tmpFemaleBirth , Rank = tmpFemaleRank, Popularity.Ratio = tmpFemaleRatio)
    } else {df.female = NULL}
    a <- rbind(df.male, df.female)
    return(a)
  }
  
  DataPopularity <- reactive({
    req(input$NameSelector1)
    name <- input$NameSelector1
    url <- paste0("https://www.behindthename.com/name/",name)
    webpage  <- read_html(url)
    titles <- webpage %>%
      html_nodes(".namedef") %>% html_text()
    output$details <- renderText(titles[1])
    p(name)
  })
  
  
  
  output$linePlot <- renderGirafe({
    GenderColor <- c("#3498db", "#ff69b4")
    BoyColor <- "#3498db"
    GirlColor <- "#ff69b4"
    PopularityPlot <- ggplot() +
      geom_line_interactive(data = filter(DataPopularity(), Gender == "Male"), aes(x = Decade, y = Rank), size = 1, colour = BoyColor) +
      geom_point_interactive(data = filter(DataPopularity(), Gender == "Male"), aes(x = Decade, y = Rank, tooltip = paste0("Decade - ", Decade, "\nRank - ", Rank, "\nTotal Number of Births - ", Births), data_id = Decade), size = 2, colour = BoyColor) +
      geom_line_interactive(data = filter(DataPopularity(), Gender == "Female"), aes(x = Decade, y = Rank), size = 1, colour = GirlColor) +
      geom_point_interactive(data = filter(DataPopularity(), Gender == "Female"), aes(x = Decade, y = Rank, tooltip = paste0("Decade - ", Decade, "\nRank - ", Rank, "\nTotal Number of Births - ", Births), data_id = Decade), size = 2, colour = GirlColor) +
      xlim(1910, 2010) +
      ylim(101, 0)
    
    girafe_options(girafe(ggobj = PopularityPlot), opts_tooltip(
      css = NULL,
      offx = 12,
      offy = 10,
      use_cursor_pos = TRUE,
      opacity = 0.7,
      use_fill = FALSE,
      use_stroke = FALSE,
      delay_mouseover = 200,
      delay_mouseout = 500,
      placement = c("auto", "doc", "container"),
      zindex = 999
    ))
  })
  
}