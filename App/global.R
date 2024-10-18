
### Library

library(shiny)
library(shinydashboard)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(fresh)
library(DT)
library(ggiraph)
library(rvest)




### Loading Required Data

male <- read.csv(file = "Data/male.csv")
female <- read.csv(file = "Data/female.csv")
common <- read.csv(file = "Data/common.csv")
common <- rbind(male,female)
baby_names <- read.csv(file = "Data/topusbabynames_bydecades.csv")

### For Names by Letter Analysis
letter.choices <- LETTERS

### Data, Variable for Popularity of Names Analysis
m.unique <- unique(as.vector(male$Name))
f.unique <- unique(as.vector(female$Name))
c.unique <- sort(unique(as.vector(append(m.unique,f.unique))))
name.choices <- c.unique
test.data <- filter(male,Name == "John")

my_theme = create_theme(
  adminlte_color(
    light_blue= "#FF8FA4"
  )
)