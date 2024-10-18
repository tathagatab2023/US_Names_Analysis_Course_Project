
# Baby Name Explorer - RShiny App

This is an interactive R Shiny application that delves into the fascinating world of baby names in the United States from 1920 to 2010. This app allows users to explore and analyze the trends of the top 100 baby names for each decade, providing valuable insights into naming patterns over the years.

Discover interesting patterns, compare names, and gain insights into the evolution of baby naming trends.


## Features
- **Decade-wise Analysis**: Dive into the rich history of baby names, exploring shifts and trends across different decades.

- **Interactive Visualizations**: The app offers a variety of interactive plots and visualizations, empowering users to dynamically observe and understand the popularity of specific names.

- **User-Friendly Interface**: With an intuitive design, users can effortlessly navigate through the app, making exploration and analysis an engaging experience.

## Demo

### This is our Dashboard (Home)
It contains information about all the Panels of our Name Popularity App

![Home](/App/Screenshots/Home.png?raw=true)

### Panel 1 : Rank Table
This panel shows a table of Top Ranked Names from the selected decade.

Change the decade and Number of Name to display
![RankTable](/App/Screenshots/RankTable.png?raw=true)

Selecting any name from the table will show its past performance in Anaytics Tab
![RankTableAnalytics](/App/Screenshots/RankTableAnalytics.png?raw=true)

### Panel 2 : Initial Letter Analysis
This panel displays a plot of Total numbers of Names vs Initial Letter

Choose either one letter or multiple letters and display them simultaneously on the same graph.
![InitialLetter](/App/Screenshots/InitialLetter.png?raw=true)

### Panel 3 : Total Number vs Rank Analysis
This panel displays a plot of Total numbers of Names vs Rank

Choose the decade and number of name to plot
![TotalNumbervsRank](/App/Screenshots/TotalNumbervsRank.png?raw=true)

### Panel 4 : Name Specific Analysis
This panel plots the a line graph of Rank vs Decade of a specific name that ever made it to the Top 100 list in any decade

Selected any name to display it performance and some information about the name (Meaning and History)
![NameSpecific](/App/Screenshots/NameSpecific.png?raw=true)



## Usage (Local Installation)

To run the app locally, follow the installation instructions provided below -

1. Download the app folder and extract it.

2. Open any *.R file from this folder in rstudio. Rstudio will detect the file automatically. (May require rshiny package installed)

3. Click on Run App button to execute it.
## R Dependencies

- [dplyr](https://cran.r-project.org/package=dplyr)
- [tidyverse](https://www.tidyverse.org/)
- [rvest](https://rvest.tidyverse.org/)
- [shiny](https://shiny.posit.co/)
- [shinydashboard](https://rstudio.github.io/shinydashboard/)
- [ggplot2](https://ggplot2.tidyverse.org/)
- [ggiraph](https://cran.r-project.org/package=ggiraph)
- [DT](https://rstudio.github.io/DT/shiny.html)

## License

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)


The shiny app as a whole is licensed under the GPLv3.
