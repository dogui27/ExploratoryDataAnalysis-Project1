
# ********************************************
# Exploratory Data Analysis - Course Project 1
# ********************************************

library(dplyr)
library(data.table)

### ***************************
### SETTING Work Directory ####
### ***************************

# Clean up the environment
rm(list = ls()); gc()

path <- file.path("C:", "mio", "R", "Coursera",
                  "4-Exploratory Data Analysis",
                  "Assignment",
                  "ExploratoryDataAnalysis-Project1")

setwd(path)
getwd()

### *************************************************
### DOWNLOAD file from Web (if not existing yet) ####
### *************************************************

fileName <- "household_power_consumption"

if (!file.exists(paste0("0_InputFiles/", fileName, ".txt"))) {
    if (!file.exists("0_InputFiles")) {
        dir.create("0_InputFiles")
    }
    
    fileURL <- paste0("https://archive.ics.uci.edu/ml/machine-learning-databases/00235/",
                      fileName, ".zip")

    download.file(url = fileURL,
                  destfile = paste0("0_InputFiles/", fileName, ".zip"),
                  method = "curl")
  
  
    unzip(zipfile = paste0("0_InputFiles/", fileName, ".zip"),
          exdir = "./0_InputFiles")
}

### ******************************************
### READING IN and TRANSFORMING data file ####
### ******************************************

all <- fread(file =  paste0("./0_InputFiles/", fileName, ".txt"), sep = ";")

# Subsetting data to focus on 2007-02-01 and 2007-02-02
df <- all %>% 
    mutate(Date = as.Date(strptime(Date, format = "%d/%m/%Y"))) %>% 
    filter(Date %in% c(as.Date("2007-02-01"), as.Date("2007-02-02")))

# Transforming some variables
df <- df %>% 
    mutate(datetime = as.POSIXct(paste(Date, Time, " ")),
           across(starts_with("Global_"), as.numeric),
           Voltage = as.numeric(Voltage),
           across(starts_with("Sub_metering_"), as.numeric))

### ***********************
### CREATING plot file ####
### ***********************

# Assign the locale
Sys.setlocale("LC_ALL","English")

# Empty plot
plot(df$datetime, df$Sub_metering_1,
     type = "n",
     main = "",
     xlab = "",
     ylab = "Energy sub metering")

# Adding Lines
with(df, lines(datetime, Sub_metering_1, col="black"))
with(df, lines(datetime, Sub_metering_2, col="red"))
with(df, lines(datetime, Sub_metering_3, col="blue"))

# Adding legend
legend("topright",
       lty = 1,
       col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       cex = 0.75,
       y.intersp = 0.6)

dev.copy(png, file = "./plot3.png")
dev.off()
