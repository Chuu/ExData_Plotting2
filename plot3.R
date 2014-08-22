#Reads in the raw data, merges the two tables, and returns the merged table
ReadMerged <- function()
{
  NEI <- readRDS("summarySCC_PM25.rds");
  SCC <- readRDS("Source_Classification_Code.rds");
  return(merge(NEI, SCC))
}

#Load necessary libraries
library(plyr);
library(ggplot2);

#Read in data, then sum emissions by Year, FIPS, and Type, then filter to Baltimore
data <- ReadMerged();
summedData <- ddply(data, .(year, fips, type), function(x) { sum(x$Emissions)});
filter <- which(summedData$fips == 24510);
summedData <- summedData[filter, ];

#Note we're using png() instead of dev.copy() to avoid resizing issues as per TA Comment
png(filename="plot3.png", width = 800, height = 600);

#Plot the data by Type.  Use custom X ticks again, and facet by Type
ggplot(data = summedData, aes(x=year, y=V1)) +
  geom_line() + geom_point(size=3) + 
  facet_grid(type~.) +
  scale_x_continuous(breaks=unique(summedData$year)) +
  labs(x = "Year", y = "Total Emissions in Tons", 
       title="Total Emissions by Year @ Baltimore City, Maryland By Type");

#Save the PNG
dev.off();
