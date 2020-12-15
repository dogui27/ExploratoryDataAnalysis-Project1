
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

par(mar = c(4, 4, 1, 1)) 

hist(df$Global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

dev.copy(png, file = "./plot1.png")
dev.off()
