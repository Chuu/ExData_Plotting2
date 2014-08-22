#Reads in the raw data, merges the two tables, and returns the merged table
ReadMerged <- function()
{
  NEI <- readRDS("summarySCC_PM25.rds");
  SCC <- readRDS("Source_Classification_Code.rds");
  return(merge(NEI, SCC))
}

#Load necessary libraries
library(ggplot2);

#Read in data, then filter just to Coal Combustion sources
data <- ReadMerged();
filter <- which(data$EI.Sector == "Fuel Comb - Electric Generation - Coal")
coalData <- data[filter, ]

#Note we're using png() instead of dev.copy() to avoid resizing issues as per TA Comment
png(filename="plot4.png", width = 800, height = 600);

#We have quite a bit of discression on what to plot.  I personally would rather have
#two plots here, one with the aggregated data and one broken down by SCC Levels, 
#but we're supposed to submit *one* plot.  In this case the data from the 
#summed plot is compelling enough that it's the one I choose to submit.

summedData <- ddply(coalData, .(year), function(x) { sum(x$Emissions)});
plot(summedData$year, summedData$V1, type="b", 
     main = "Total Emissions by Year from Coal Combustion Sources", 
     xlab = "Year", ylab = "Total Emissions in Tons",
     xaxt = "n");
axis(1, at=unique(summedData$year));

dev.off();