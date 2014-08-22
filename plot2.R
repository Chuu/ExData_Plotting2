#Reads in the raw data, merges the two tables, and returns the merged table
ReadMerged <- function()
{
  NEI <- readRDS("summarySCC_PM25.rds");
  SCC <- readRDS("Source_Classification_Code.rds");
  return(merge(NEI, SCC))
}

#Read in data
data <- ReadMerged();
filter <- which(data$fips == 24510);
baltEmissionsByYear <- tapply(data$Emissions[filter], data$year[filter], sum);

#Note we're using png() instead of dev.copy() to avoid resizing issues as per TA Comment
png(filename="plot2.png", width = 800, height = 600);

#Plot the values without an X Axis, and use a custom X axis s.t. it's more obvious what
#year each measurement is for
plot(names(baltEmissionsByYear), baltEmissionsByYear, type="b", 
     main = "Total Emissions by Year @ Baltimore City, Maryland", 
     xlab = "Year", ylab = "Total Emissions in Tons",
     xaxt = "n");
axis(1, at=names(baltEmissionsByYear));

#Save the PNG
dev.off();