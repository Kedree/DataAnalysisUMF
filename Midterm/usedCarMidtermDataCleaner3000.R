setwd('C:/Users/Kedree Proffitt/Downloads/archive(3)') # Sets my WD

df = read.delim('vehicles.csv', sep = ',', header = TRUE) # Read in huge data set
cols.delete <- c("id","url","region","region_url","image_url", "description", "county", "lat", "long") # Deletes all non-stubborn (VIN) columns we dont need

df <- df[, ! names(df) %in% cols.delete, drop = F] # Deletes dumb columns by name for ease
#dfclean <- na.omit(df) # Deltes rows with NAs
df <- df[complete.cases(df), ]
df <- df[!(df$price<=200),] # Deletes all cars with a price of <=200
df <- df[!(df$title_status=="salvage"),] # Deletes all salvage cars, we ideally wont functional or semi-functional cars
df[11] <- NULL # Deletes vin because it refuses to be deleted via name above

sum(df$odometer >= 750000) # tell us how many cars have a stupid number of miles like 9999999 or 2222222

df <- df[!(df$odometer >= 750000),]

df <- df[!(df$price<=200),] # Delete the aforementioned dumb odometer rows

write.csv(df,"vehiclesClean3.csv", row.names = FALSE) # Save the cleaned data
