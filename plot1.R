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

# Sum the emissions for each year
summedemissions <- with(NEI, tapply(Emissions,year,sum,na.rm=TRUE)) # calculate the mean sample value for each state code

# Open a connection in which the plot will be saved
png("plot1.png", width = 480, height = 480)

# Plot the summed emissions
barplot(summedemissions, xlab = "Year", ylab = "Total PM-25 concentration", main = "Total PM-25 concentration per year in the US", names.arg=c("1999","2002","2005","2008"))

# Close the connection
dev.off()
