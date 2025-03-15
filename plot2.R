# Script to create plot2.png
# Answers the question: Have total PM2.5 emissions decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# Plotting system: base

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

# Calculate the mean PM2.5 emission per year
meanbaltimore <-with(baltimore2, aggregate(Emissions, by=list(year),mean,na.rm=TRUE)) 

# Open a connection in which the plot will be saved
png("plot2.png", width = 480, height = 480)

# Plot the summed emissions
plot(meanbaltimore,xlab="Year",ylab="PM2.5 emission",main="Mean Baltimore City PM2.5 emissions from 1999 to 2008",pch=20,cex=2,col="purple")

# Close the connection
dev.off()
