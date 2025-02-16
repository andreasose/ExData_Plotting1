##Downloading and getting the data to use:
FileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

##Change the destination to where you want to save the file. Afterwards you need to unzip the file.
download.file(FileUrl, destfile = "./Rfolder")

##na.strings set to "?". Could also use data.table to load data, but this works too. It does take some time to load
data_power <- read.csv("./Rfolder/household_power_consumption.txt", header=T, sep=';', na.strings="?", 
                       nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
##Makes the format easier to search
data_power$Date <- as.Date(data_power$Date, format="%d/%m/%Y")

## This subset the data to only the 2 days we are plotting
data_subset <- subset(data_power, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))


## This converts the dates into the format I wanted using as.POSIXct, which converts calendar dates and times
date_time <- paste(as.Date(data_subset$Date), data_subset$Time)
data_subset$Datetime <- as.POSIXct(date_time)


## Plot 4 combining al the graphs. Wow it took long to do this, even if I had prev. graphs
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(data_subset, {plot(Global_active_power~Datetime, type="l", 
                        ylab="Global Active Power (kilowatts)", xlab="")
  plot(Voltage~Datetime, type="l", ylab="Voltage (volt)", xlab="")
  plot(Sub_metering_1~Datetime, type="l", ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~Datetime,col='Red')
  lines(Sub_metering_3~Datetime,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Global_reactive_power~Datetime, type="l", 
       ylab="Global Rective Power (kilowatts)",xlab="")})

## Saving to file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
