#Code for visualizations in R

data <- read.csv("topusbabynames_bydecades.csv")
attach(data)
#Barplot

library(ggplot2)
library(gridExtra)

# Calculate the total number of babies' names starting with each letter
total_names <- table(c(substr(data$Male.Name, 1, 1), substr(data$Female.Name, 1, 1)))

# Create a data frame for plotting
names_data <- data.frame(InitialLetter = names(total_names), TotalBabies = as.numeric(total_names))

# Sort data frame by Initial Letter
names_data <- names_data[order(names_data$InitialLetter), ]

# Print the data frame (optional)
print(names_data)

# Plotting the bar plot
barplot(names_data$TotalBabies, names.arg = names_data$InitialLetter, 
        xlab = "Initial Letter", ylab = "Total Number of Babies", 
        main = "Total Number of Babies' Names by Initial Letter",
        col = rainbow(length(names_data$InitialLetter)))

# Adding legend (optional)
legend("topright", legend = names_data$InitialLetter, fill = rainbow(length(names_data$InitialLetter)), cex = 0.8)


#########################################################################
#Pie chart

names_data$Percentage <- names_data$TotalBabies / sum(names_data$TotalBabies) * 100

# Creat a pie chart for the top 10 percentages
# Sort the data frame by Percentage in descending order and select the top 10 rows
top_10_names <- names_data[order(-names_data$Percentage), ][1:10, ]

# Sort the data frame by Percentage in descending order
names_data <- names_data[order(-names_data$Percentage), ]

# Create a pie chart for all letters
ggplot(names_data, aes(x = "", y = TotalBabies, fill = InitialLetter)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y") +
  theme_void() +
  theme(legend.position = "right") +
  scale_fill_manual(values = rainbow(length(unique(names_data$InitialLetter)))) +
  geom_text(aes(label = ifelse(Percentage >= quantile(Percentage, 0.6), scales::percent(Percentage / 100), "")), 
            position = position_stack(vjust = 0.5)) +
  ggtitle("Distribution of Babies' Names by Initial Letter")

############################################

#boxplot
# Calculate mean number of babies for each decade (both male and female)
mean_babies <- aggregate(cbind(No..of.babies.M., No..of.babies.F.) ~ Decade, data = data, FUN = mean)

par(mfrow = c(1,2))

# Boxplot for Male Names
boxplot(mean_babies$No..of.babies.M., main = "Boxplot of mean no. of male babies", ylab = "Count", names = "Male", col = "skyblue")

# Boxplot for Female Names
boxplot(mean_babies$No..of.babies.F., main = "Boxplot of mean no. of female babies", ylab = "Count", names = "Female", col = "pink")

##################################################
#Horizontal line plot

# Calculate total number of births for each male name
total_births <- aggregate(No..of.babies.F. ~ Female.Name, data = data, FUN = sum)

# Sort the data by total number of births in descending order
sorted_data <- total_births[order(-total_births$No..of.babies.F.), ]

# Select top 50 and bottom 50 male names
top_50 <- head(sorted_data, 50)
bottom_50 <- tail(sorted_data, 50)

# Create horizontal line plots for top 50 and bottom 50 male names
plot_top_50 <- ggplot(top_50, aes(y = reorder(Female.Name, No..of.babies.F.), x = No..of.babies.F.)) +
  geom_point() +
  geom_segment(aes(xend = 0, yend = reorder(Female.Name, No..of.babies.F.)), color = "magenta") +
  labs(y = "Female Names", x = "Total Number of Babies", title = "Top 50 Female Names by Total Number of Babies") +
  theme(axis.text.y = element_text(hjust = 1))

plot_bottom_50 <- ggplot(bottom_50, aes(y = reorder(Female.Name, No..of.babies.F.), x = No..of.babies.F.)) +
  geom_point() +
  geom_segment(aes(xend = 0, yend = reorder(Female.Name, No..of.babies.F.)), color = "magenta") +
  labs(y = "Female Names", x = "Total Number of Babies", title = "Bottom 50 Female Names by Total Number of Babies") +
  theme(axis.text.y = element_text(hjust = 1))

# Arrange plots side by side
grid.arrange(plot_top_50, plot_bottom_50, ncol = 2)


#########################################################################
#Scatterplot

calculateNameLength <- function(name) {
  nchar(gsub("[^A-Za-z]", "", name))
}


# Calculate name length for males and females
data$Male.Name.Length <- sapply(data$Male.Name, calculateNameLength)
data$Female.Name.Length <- sapply(data$Female.Name, calculateNameLength)

# Calculate mean rank for males and females
male_mean_rank <- aggregate(Decadewise.Rank ~ Decade + Male.Name.Length, data = data, FUN = mean)
female_mean_rank <- aggregate(Decadewise.Rank ~ Decade + Female.Name.Length, data = data, FUN = mean)

# Plot for female names with legend outside the plot based on color and name length
par(mfrow= c(2,1))

plot1 = ggplot(data = female_mean_rank, aes(x = Decade, y = Decadewise.Rank, color = factor(Female.Name.Length))) +
  geom_point(size = 3, shape = 16) +
  labs(title = "Mean Rank vs. Decade for Females",
       x = "Decade",
       y = "Mean Rank",
       color = "Name Length") +
  theme_minimal() +
  theme(legend.position = "top") +
  
  # Set custom breaks and limits on the x-axis
  scale_x_continuous(breaks = seq(1910, 2020, by = 10), limits = c(1910, 2020), expand = c(0, 0))

plot2 = ggplot(data = male_mean_rank, aes(x = Decade, y = Decadewise.Rank, color = factor(Male.Name.Length))) +
  geom_point(size = 3, shape = 16) +
  labs(title = "Mean Rank vs. Decade for Males",
       x = "Decade",
       y = "Mean Rank",
       color = "Name Length") +
  theme_minimal() +
  theme(legend.position = "top") +
  
  # Set custom breaks and limits on the x-axis
  scale_x_continuous(breaks = seq(1910, 2020, by = 10), limits = c(1910, 2020), expand = c(0, 0))

grid.arrange(plot1,plot2,ncol=2)



####################################################################################

#plot of common names

mn=data$Male.Name
fn=data$Female.Name
store=intersect(mn,fn)
mn1 = numeric(length = 20)
fn1 = numeric(length=20)
j = 1
for(i in 1:5)
{
  print(which(mn == store[i]))
}

for(i in 1:5)
{
  print(which(fn == store[i]))
}

mn1= c(28,133,238,353,492,232,329,437,569,579,660,728,838,961,765)
fn1 = c(72,397,540,634,785,753,875,709,817,969)
malecom = data[mn1,]

femalecom = data[fn1,]

com = rbind(malecom,femalecom)

gender = c(rep("M",15),rep("F",10))

com = cbind(com,gender)

name = c(com[1:15,3],com[16:25,5])

com = cbind(com,name)
com = com[,c(1,2,9,10)]

colnames(com) = c("Decade","Decadewise.Rank","Gender","Name")


ggplot(com, aes(x = Decade, y = Decadewise.Rank, color = Name)) +
  geom_point(aes(shape = Gender), size = 3) +
  geom_line(aes(group = interaction(Name, Gender))) +
  labs(title = "Rank of Common Names across Decades",
       x = "Decade",
       y = "Rank",fontface = "bold",
       fontsize = 20,
       title.position = c(5, 1)) +
  theme_minimal() +
  theme(plot.background = element_rect(fill = "gray")) +
  guides(label.position = "bottom")

#####################################################################################

#Scatterplot of mean rank vs decade for letter

calculateNameLength <- function(name) {
  substr(name,"1","1")
}


# Calculate name length for males and females
data$Male.Name.Length <- sapply(data$Male.Name, calculateNameLength)
data$Female.Name.Length <- sapply(data$Female.Name, calculateNameLength)

# Calculate mean rank for males and females
male_mean_rank <- aggregate(Decadewise.Rank ~ Decade + Male.Name.Length, data = data, FUN = mean)
female_mean_rank <- aggregate(Decadewise.Rank ~ Decade + Female.Name.Length, data = data, FUN = mean)

# Plot for female names with legend outside the plot based on color and name length
male_agg=aggregate(Decadewise.Rank~Male.Name.Length,data=male_mean_rank,mean)
library(dplyr)
male_top=arrange(male_agg,male_agg$Decadewise.Rank)[1:10,1]

fem_agg=aggregate(Decadewise.Rank~Female.Name.Length,data=female_mean_rank,mean)
fem_top=arrange(fem_agg,fem_agg$Decadewise.Rank)[1:10,1]
final_m = subset(male_mean_rank, Male.Name.Length %in% male_top)
final_f = subset(female_mean_rank,Female.Name.Length %in% fem_top)

plot1 = ggplot(data = final_f, aes(x = Decade, y = Decadewise.Rank, color = factor(Female.Name.Length))) +
  geom_point(size = 3, shape = 16) +
  labs(title = "Mean Rank vs. Decade for Females",
       x = "Decade",
       y = "Mean Rank",
       color = "Initial Letter") +
  theme_minimal() +
  theme(legend.position = "top") +
  theme(plot.background = element_rect(fill = "gray"))+
  
  # Set custom breaks and limits on the x-axis
  scale_x_continuous(breaks = seq(1910, 2020, by = 10), limits = c(1910, 2020), expand = c(0, 0))

plot2 = ggplot(data = final_m, aes(x = Decade, y = Decadewise.Rank, color = factor(Male.Name.Length))) +
  geom_point(size = 3, shape = 16) +
  labs(title = "Mean Rank vs. Decade for Males",
       x = "Decade",
       y = "Mean Rank",
       color = "Initial Letter") +
  theme_minimal() +
  theme(legend.position = "top") +
  theme(plot.background = element_rect(fill = "gray")) +
  
  # Set custom breaks and limits on the x-axis
  scale_x_continuous(breaks = seq(1910, 2020, by = 10), limits = c(1910, 2020), expand = c(0, 0))

grid.arrange(plot1,plot2,ncol=2)









