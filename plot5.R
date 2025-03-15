# Script to create plot5.png
# Answers the question: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
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

# Select the SCCs with vehicles only in NEI dataframe
index <- grep('vehicle',SCC$EI.Sector,value=FALSE,ignore.case=TRUE)
sources <- SCC$SCC[index]
vehiclesubset <- subset(NEI, SCC %in% sources) # select the relevant sources (rows) in NEI dataframe

# Select only Baltimore City
baltimore <- vehiclesubset[vehiclesubset$fips == "24510",] 

library(ggplot2)

# Open a connection in which the plot will be saved
png("plot5.png", width = 480, height = 480)

baltimore$year <- as.factor(baltimore$year)

# Plot
# Violin plot (not great y axis): 
ggplot(baltimore, aes(x=year, y=Emissions)) + geom_violin(fill="blue") + 
    stat_summary(fun.y=mean, geom="point", shape=21, size=2, color="red",fill="red") +
    labs(title = "Vehicle-related emissions per year in Baltimore City", x = "Year", y = "PM2.5 emissions", caption="Violin plot, red dot indicates the mean PM2.5") + 
    theme_classic() + coord_cartesian(ylim=c(0,7))
# source for violin plot: http://www.sthda.com/english/wiki/ggplot2-violin-plot-quick-start-guide-r-software-and-data-visualization

# Close the connection
dev.off()
