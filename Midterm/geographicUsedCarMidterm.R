#Kedree
library(maps) # Obligatory Imports
library(mapdata)
library(ggplot2)
library(dplyr)

setwd("C:/Users/Kedree Proffitt/Downloads/archive(3)") # Set it to my working directory

states <- map_data("state") # Get our mapping data
cars = read.delim('vehiclesClean3.csv', sep = ',', header = TRUE) # Read in our cars data

colnames(cars)[15] <- 'region' # Make sure the region column names are identical
colnames(states)[5] <- 'region'

carsGroup <- cars %>% count(region) # Group the cars by state and count them

choro <- merge(states, carsGroup, sort = FALSE, by = 'region') # Merge the counts and states polygons

choro <- choro[order(choro$order), ] # Order the polygons for correct display

# Map the merged dataset, choro is the merged, geom_polygon fills the color with the number of cars, the rest is mumbo jumbo
ggplot(choro, aes(long, lat)) +
  geom_polygon(aes(group = group, fill = n)) +
  coord_map("albers",  lat0 = 45.5, lat1 = 29.5)
