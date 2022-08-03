library(maps) # Obligatory Imports
library(mapdata)
library(ggplot2)
library(dplyr)

setwd("C:/Users/Kedree Proffitt/Downloads")

states <- map_data("state") # Get our mapping data

states <- states %>% filter(region=="california")

load(file='wind_turbines.rda')

wind_ca <- wind_turbines %>% filter(t_state == "CA")

ggplot(states, aes(long, lat)) +
  geom_polygon() +
  geom_point(wind_ca, colour = "red", size = 1.5, mapping=aes(xlong, ylat)) +
  coord_map("albers",  lat0 = 45.5, lat1 = 29.5) +
  ggtitle("Wind Turbines In California") +
  xlab("") + ylab("") +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank()) +
  theme(axis.text.y = element_blank(), axis.ticks = element_blank())
