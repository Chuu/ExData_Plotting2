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
filter <- which(data$fips == 24510
                & data$EI.Sector %in% unique(grep("Mobile", data$EI.Sector, value=TRUE)));
baltimoreMotor<- data[filter, ];

#Note we're using png() instead of dev.copy() to avoid resizing issues as per TA Comment
png(filename="plot5.png", width = 800, height = 600);

#What I'm trying to emphasize in this graph is how important the Marine Vessel component
#is to the total emissions in baltimore city, since it's such a large percentage
#plus it's increase from 2005 to 2008 is the major contributor to the "V" shape.
summedData <- ddply(baltimoreMotor, .(year, SCC.Level.Two), function(x) { sum(x$Emissions)});

ggplot(data = summedData, aes(x=year, y=V1, fill=SCC.Level.Two)) +
  geom_bar(stat = "identity") + 
  scale_x_continuous(breaks=unique(summedData$year)) +
  labs(x = "Year", y = "Total Emissions in Tons", 
       title="Total Emissions by Year By Motor Vehicles @ Baltimore City, Maryland With SCC Level 2 Data Detail");

dev.off();
