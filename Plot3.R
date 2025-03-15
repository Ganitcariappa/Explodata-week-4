# Script to create plot3.png
# Answers the question: which of the 4 sources (point, nonpoint, onroad, nonroad) have seen decreases in emissions from 1999–2008 
# for Baltimore City? Which have seen increases in emissions from 1999–2008? 
# Plotting system: ggplot2

# Set working directory (change this to the folder where your original data are located)
setwd("C:/Users/dorie/Documenten/201912_Coursera_Data_Science_Specialization/4. Exploratory data analysis/Week_4_Course_Project/ExplDataAn_CourseProjectWeek4")

# Download the data
zipfileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
install.packages("downloader")
library(downloader)
download(zipfileURL,destfile="Emissiondata.zip", mode="wb")
unzip("Emissiondata.zip", exdir = ".")

# Read in the data
NEI <- readRDS("summarySCC_PM25.rds") # emissions data
SCC <- readRDS("Source_Classification_Code.rds") # source classifications code

# Make a dataframe containing only data of fips 24510 (Baltimore City)
baltimore <- subset(NEI, fips=="24510")

# Load packages
library(ggplot2)
library(dplyr)

# Create a dataframe with mean emissions per year and type
summarybaltimore <- baltimore %>% 
    group_by(type = as.factor(type),year = as.factor(year)) %>% 
    summarise(Emissions = mean(Emissions))

# Open a connection in which the plot will be saved
png("plot3.png", width = 680, height = 480)

# Plot
g <- ggplot(summarybaltimore, aes(year,Emissions))
g+geom_point(colour = "darkgreen", size = 2)+facet_grid(.~type,margins=FALSE)+ ggtitle("Baltimore City emissions per year and source")

# Close the connection
dev.off()
