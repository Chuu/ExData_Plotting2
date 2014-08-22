#Reads in the raw data, merges the two tables, and returns the merged table
ReadMerged <- function()
{
  NEI <- readRDS("summarySCC_PM25.rds");
  SCC <- readRDS("Source_Classification_Code.rds");
  return(merge(NEI, SCC))
}

#Load necessary libraries
library(ggplot2);
library(plyr);

#Read in data, then filter just to Coal Combustion sources
data <- ReadMerged();
filter <- which((data$fips == "24510" | data$fips == "06037")
                & data$EI.Sector %in% unique(grep("Mobile", data$EI.Sector, value=TRUE)));
motor<- data[filter, ];

#Note we're using png() instead of dev.copy() to avoid resizing issues as per TA Comment
png(filename="plot6.png", width = 800, height = 600);

#What I'm trying to emphasize in this graph is the different ratio in components between
#the two cities.  The "Freely Scaled" in the title is a hint to look at the axis, since they're scaled
#so differently.  The answer to the question is very highly dependent on the metrics you are using
#so it's pretty tough to capture in one graph.
summedData <- ddply(motor, .(year, SCC.Level.Two, fips), function(x) { sum(x$Emissions)});

#We're going to change the FIPS labels to something human readable for ggplot to work with
summedData$fips[summedData$fips == "24510"] <- "Baltimore City";
summedData$fips[summedData$fips == "06037"] <- "Los Angeles County";

ggplot(data = summedData, aes(x=year, y=V1, fill=SCC.Level.Two)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~ fips, ncol=1, scale="free") + 
  scale_x_continuous(breaks=unique(summedData$year)) +
  labs(x = "Year", y = "Total Emissions in Tons", 
       title="Total Emissions by Year By Motor Vehicles With SCC Level 2 Detail [Freely Scaled]");

dev.off();
