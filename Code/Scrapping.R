library(rvest)
library(dplyr)



func = function(dec) #function to scrape the required data from the ssa.gov website and clean it
{
  link <- paste0("https://www.ssa.gov/oact/babynames/decades/names",dec,"s.html")
  
  html <- read_html(link)
  
  dat <- html %>% html_table()
  t = dat[[1]]
  
  data = t[3:102,]
  data_cleaned <- data %>% mutate_all(~gsub(",", "", .))
  
  return(data_cleaned)
  
}



# Creating a blank tibble with 5 columns

store <- tibble(
  Column1 = c(),
  Column2 = c(),
  Column3 = c(),
  Column4 = c(),
  Column5 = c()
)

dec = seq(1920,2010,10)

for(i in 1:10) #saving the data from decades 1920-2010 in a tibble
{
  store = bind_rows(store,func(dec[i]))
}

decade <- rep(dec,each=100)

new_tibble <- store %>% mutate(NewColumn = decade) #adding the decade column to the tibble

colnames(new_tibble) <- c("Decadewise Rank","Male Name","No. of births(M)","Female Name","No. of births(F)","Decade")

us_babynames <- new_tibble %>%  select(Decade, everything()) #storing the final cleaned data in a tibble

write.csv(us_babynames, file = "topusbabynames_bydecades.csv", row.names = FALSE) #saving the data in csv file

