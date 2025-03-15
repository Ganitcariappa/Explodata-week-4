# Script to create plot4.png
# Answers the question: Across the US, how have emissions from coal combustion-related sources changed from 1999–2008?
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

# Search for coal-related sources in the SCC data
index <- grep("coal",SCC$EI.Sector,value=FALSE,ignore.case = TRUE)
sources <- SCC$SCC[index] # select the sources that we will subset NEI with

coalsubset <- subset(NEI, SCC %in% sources) #select the relevant sources (rows) in NEI dataframe

library(dplyr)
library(ggplot2)
summarycoal <- coalsubset %>% 
    group_by(year = as.factor(year)) %>% 
    summarise(MeanEmissions = mean(Emissions,na.rm=TRUE),
              MinEmissions = min(Emissions,na.rm=TRUE),
              MaxEmissions = max(Emissions, na.rm=TRUE),
              SDEmissions=sd(Emissions,na.rm=TRUE),
              sumEmissions = sum(Emissions,na.rm=TRUE))

# Open a connection in which the plot will be saved
png("plot4.png", width = 480, height = 480)

# Plot
q <- ggplot(summarycoal, aes(year,MeanEmissions))+geom_line() 
q+geom_point() + geom_errorbar(aes(ymin = MeanEmissions-(SDEmissions/2), ymax=MeanEmissions+(SDEmissions/2)),width=.2,position=position_dodge(0.05)) +
    labs(title = "Coal-related emissions per year across the US", x = "Year", y = "Mean PM2.5 emissions", caption="Mean PM2.5 emissions. Error bars represent 1 SD") +
    theme_classic()

# Close the connection
dev.off()
