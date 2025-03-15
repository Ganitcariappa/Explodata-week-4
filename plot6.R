# Script to create plot6.png
# Answers the question: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County,
#     California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
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

# Select only Baltimore City and LA
baltimore <- vehiclesubset[vehiclesubset$fips == "24510",] 
LA <- vehiclesubset[vehiclesubset$fips == "06037",]

library(ggplot2)
baltimore$year <- as.factor(baltimore$year)
LA$year <- as.factor(LA$year)

# Extra ggplot package, source: http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/
if(!require(devtools)) install.packages("devtools")
devtools::install_github("kassambara/ggpubr")
# The above failed, so:
install.packages("ggpubr")

library(ggpubr)

# Open a connection in which the plot will be saved
png("plot6.png", width = 850, height = 480)

# Violin plot 
baltimoreplot <- ggplot(baltimore, aes(x=year, y=Emissions)) + geom_violin(fill="blue") + 
    stat_summary(fun=mean, geom="point", shape=21, size=2, color="red",fill="red") +
    labs(x = "Year", y = "PM2.5 emissions") + theme_classic() + coord_cartesian(ylim=c(0,100))
# source for violin plot: http://www.sthda.com/english/wiki/ggplot2-violin-plot-quick-start-guide-r-software-and-data-visualization

LAplot <- ggplot(LA, aes(x=year, y=Emissions)) + geom_violin(fill="blue") + 
    stat_summary(fun=mean, geom="point", shape=21, size=2, color="red",fill="red") +
    labs(x = "Year", y = "PM2.5 emissions") + theme_classic() + coord_cartesian(ylim=c(0,100))

# Combine the plots in one figure
both <- ggarrange(baltimoreplot,LAplot, labels= c("Baltimore City","LA county"))
annotate_figure(both,bottom=text_grob("Violin plot, red dot indicates the mean PM2.5",size=10),top=text_grob("Vehicle-related emissions per year",size=15,face="bold"))

# Close the connection
dev.off()
