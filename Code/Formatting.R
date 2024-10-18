library(dplyr)
library(tidyverse)

### Switch
HEADS <- FALSE ### Logs (For debugging)
LOCAL <- FALSE ### Only on my computer

### Custom Function
hed <- function(arg){
  if (HEADS == TRUE){
   head(arg)
  }
}



### Loading Data
if (LOCAL == TRUE) {base <- "E:\\Files\\IITK\\Sem 3\\MTH208\\Worksheets\\Project\\"} else { base <- ""}

loc <- paste0(base , "Raw Data\\topusbabynames_bydecades.csv")
data <- read.csv(loc)



### Dividing into Male and Female, Renaming and Rearranging
male.raw <- data[c(1,2,3,4)] %>% rename(Name = Male.Name, Rank = Decadewise.Rank)
Gender <- replicate(1000,"Male")
male.raw <- mutate(male.raw, Gender = "Male")
male <- male.raw %>% relocate(Decade,Name,Gender,Rank,Births = No..of.births.M.)
hed(male)

female.raw <- data [c(1,2,5,6)] %>% rename(Name = Female.Name, Rank = Decadewise.Rank)
Gender <- replicate(1000,"Female")
female.raw <- mutate(female.raw, Gender = "Female")
female <- female.raw %>% relocate(Decade,Name,Gender,Rank,Births = No..of.births.F.)
hed(female)

common <- rbind(male,female)
hed(common)


### I have already Created that file
#write.csv(male,file = "Formatted Data\\male.csv")
#write.csv(female,file = "Formatted Data\\female.csv")
#write.csv(male,file = "Formatted Data\\male.csv")
#write.csv(common,file = "Formatted Data\\common.csv")
