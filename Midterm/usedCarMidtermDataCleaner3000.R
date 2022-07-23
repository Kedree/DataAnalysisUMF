setwd('C:/Users/Kedree Proffitt/Downloads/archive(3)') # Sets my WD

df = read.delim('vehicles.csv', sep = ',', header = TRUE) # Read in huge data set

cols.delete <- c("id","url","region","region_url","image_url", "description", "county", "lat", "long") # Deletes all non-stubborn (VIN) columns we dont need

df <- df[, ! names(df) %in% cols.delete, drop = F] # Deletes dumb columns by name for ease

df <- df[complete.cases(df), ] # Deletes rows with NAs

df <- df[!(df$price<=200),] # Deletes all cars with a price of <=200

df <- df[!(df$title_status=="salvage"),] # Deletes all salvage cars, we ideally wont functional or semi-functional cars

df[11] <- NULL # Deletes vin because it refuses to be deleted via name above

df <- df[!(df$odometer >= 750000),] # Delete all cars with odometers >= 750000

df <- df[!(df$price <= 200),] # Delete all cars with price at <= 200

df <- df[!(df$year <= 1950),] # Delete all cars with years <= 1950

df <- df[!(df$odometer <= 40),] # Delete all cars with odometers <= 40

write.csv(df,"vehiclesClean3.csv", row.names = FALSE) # Save the cleaned data
