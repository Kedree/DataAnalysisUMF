setwd('C:/Users/Kedree Proffitt/Downloads')

# 1. Run the following lines and study how they work. Then state what they do and output for us. 
# The df1 line creates a data frame with columns: Name. State, Sales and rows of data
df1=data.frame(Name=c('James','Paul','Richards','Marico','Samantha','Ravi','Raghu',
                      'Richards','George','Ema','Samantha','Catherine'),
               State=c('Alaska','California','Texas','North Carolina','California','Texas',
                       'Alaska','Texas','North Carolina','Alaska','California','Texas'),
               Sales=c(14,24,31,12,13,7,9,31,18,16,18,14))
head(df1)
# The aggregate line sums up the sales according to the state the sale was made it
aggregate(df1$Sales, by=list(df1$State), FUN=sum)

# The library line loads the dplyr package
library(dplyr)

# The next line creates a table where the sum of the sales is given by the state they were made it similar to the aggregate
df1 %>% group_by(State) %>% summarise(sum_sales = sum(Sales))

#Use R to read the WorldCupMatches.csv from the DATA folder on Google Drive. Then perform the followings (48 points):
matches <- read.csv("WorldCupMatches.csv")
head(matches)

# (a) Find the size of the data frame. How many rows, how many columns?
# 852 rows 20 cols
nrow(matches)
ncol(matches)

# (b) Use summary function to report the statistical summary of your data.
summary(matches)

# (c) Find how many unique locations the Olympics were held at.
#151
length(unique(matches$City))

# (d) Find the average attendance.
# 45164.8 average attendance
mean(matches$Attendance, na.rm=TRUE)

# (e) For each Home Team, what is the total number of goals scored? (Hint: Please refer to question 1)
matches %>% group_by(Home.Team.Name) %>% summarise(sum_home_goals = sum(Home.Team.Goals))

# (f) What is the average number of attendees for each year? Is there a trend or pattern in the data in that sense?
# Attendance seems to have increased over time with notable outliers that show increased importance of the games probably due to international politics
matches %>% group_by(Year) %>% summarise(avg_attendance = mean(Attendance, na.rm=TRUE))

# Use R to read the metabolites.csv from the DATA folder on Google Drive. Then perform the followings (32 points):
meta <- read.csv("metabolite.csv")
head(meta)

# (a) Find how many Alzheimers patients there are in the data set. (Hint: Please refer to question 1)
# 35
meta %>% count(Label)

# (b) Determine the number of missing values for each column. (Hint: is.na( ) )
sapply(meta, function(x) sum(is.na(x)))

# (c) Remove the rows which has missing value for the dopamine column and assign the result to a new data frame. (Hint: is.na( ) )
meta_no_fun = meta[is.na(meta$Dopamine), ]
meta_no_fun$Dopamine
meta = meta[!is.na(meta$Dopamine), ]
meta$Dopamine


# (d) In the new data frame, replace the missing values in the c4-OH-Pro column with the median value of the same column. (Hint: there is median( ) function.)
meta_no_fun$c4.OH.Pro[is.na(meta_no_fun$c4.OH.Pro)]<-median(meta_no_fun$c4.OH.Pro, na.rm=TRUE)
median(meta_no_fun$c4.OH.Pro, na.rm=TRUE)
meta_no_fun$c4.OH.Pro

#(e) (Optional) Drop columns which have more than 25% missing values. (Hint: when you slice your data frame, you can use -c(.., ..., ...) where ... represent one column name)
meta_no_funCleaned = meta_no_fun[, which(colMeans(!is.na(meta_no_fun)) >= .25)]
ncol(meta_no_fun)
ncol(meta_no_funCleaned)
