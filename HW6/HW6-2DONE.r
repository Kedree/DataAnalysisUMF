library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate)

setwd("C:/Users/Kedree Proffitt/Downloads")

load(file='house_prices.rda')

ggplot(house_prices, aes(date, house_price_index)) +
geom_line() +
scale_x_continuous(name = "Date", breaks = c(ymd("1980-01-01"), ymd("2000-01-01"), ymd("2020-01-01")), labels = c("'80", "'00", "'20")) +
scale_y_continuous(name = "House Price Index") +
facet_wrap(vars(state), nrow=3, ncol=17)
  
##############################

house_reshaped <- house_prices  %>% select(-house_price_perc)
house_reshaped <- house_reshaped %>% gather(key="Measure", value="Value", house_price_index, unemploy_perc)

ggplot(house_reshaped, aes(color=Measure)) +
  geom_line(aes(date, Value)) +
  scale_x_continuous(name = "Date", breaks = c(ymd("1980-01-01"), ymd("2000-01-01"), ymd("2020-01-01")), labels = c("'80", "'00", "'20")) +
  scale_y_continuous(name = "House Price Index") +
  facet_wrap(vars(state), nrow=3, ncol=17)

#geom_line(aes(filter(house_reshaped, Measure=="house_price_index")$date, filter(house_reshaped, Measure=="house_price_index")$Value)) +
#geom_line(aes(filter(house_reshaped, Measure=="unemploy_perc")$date, filter(house_reshaped, Measure=="unemploy_perc")$Value)) +
