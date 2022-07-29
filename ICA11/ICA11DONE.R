# Instructions:
#Read the flights.csv file from the DATA folder in R.
#Generate line plots for each month over the available years.
#Give names to x and y axes.

library(ggplot2)
library(dplyr)

setwd("C:/Users/Kedree Proffitt/Downloads")

flights = read.delim('flights.csv', sep = ',', header = TRUE)

ggplot(data=flights) + geom_line(aes(x=year,y=passengers, color=month)) + theme_bw() + xlab('Year') + ylab('Number of Passengers') + ggtitle('Passengers by Year')
ggsave('ICA11PIC.jpg')
