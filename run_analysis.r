#!/usr/bin/env Rscript
# run_analysis script
#     Downloads and performs several cleaning functions on the Samsung Galaxy S accelorometer 
#     datasets and outputs a tidy dataset. See accompanying codebook.dm and script.dm for 
#     additional information.

# Determine if a working data directory exists. If not, create it.
if(!file.exists("./data")){dir.create("./data")}

# Download the zip file containing the data.
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "./data/uca_dataset.zip")

# Extract the contents of the zip file.
unzip(zipfile="./data/uca_dataset.zip", exdir = "./data")

## Now read the necessary tables in.
# Training tables.
train.x <- read.table("./data/UCI HAR dataset/train/X_train.txt", header = F)
train.y <- read.table("./data/UCI HAR dataset/train/Y_train.txt", header = F)
train.subject <- read.table("./data/UCI HAR dataset/train/subject_train.txt", header = F)
# Test datasets. 
test.x <- read.table("./data/UCI HAR dataset/test/X_test.txt", header = F)
test.y <- read.table("./data/UCI HAR dataset/test/Y_test.txt", header = F)
test.subject <-read.table("./data/UCI HAR dataset/test/subject_test.txt", header = F)
# Label and features datasets.
data.labels <- read.table("./data/UCI HAR dataset/activity_labels.txt", header=F)
data.features <- read.table("./data/UCI HAR dataset/features.txt", header=F)

## Merge the test and train datasets together.
# Bind the subject datasets together.
data.subject <- rbind(train.subject, test.subject)
# Bind the activity datasets together (x files per the readme file).
data.x <- rbind(test.x, train.x)
# Bind the activity labels datasets together (y per for the readme file).
data.y <- rbind(test.y, train.y)

## Rename the dataset headers based on the accompanying file containing header values.
# Rename the subject dataset.
names(data.subject) <- "subject"
# Merge the activity column with its key, tto be renamed when merged..
data.y <- merge(data.y, data.labels, by = "V1")[, 2]
# Finally, rename the feature values based on the features dataset.
names(data.x) <- data.features$V2

## Finally, combine all data into a single dataset.
data.full <- cbind(data.subject, data.y, data.x)

## Extract only the desired measurements of mean and standard deviation for each record.
# Extract the desired feature names from the features dataset.
feature.names <- data.features$V2[grep("mean\\(\\)|std\\(\\)", data.features[,2])]
# Now rename the activity column (currently data.y).
colnames(data.full)[2] <- "activity"
# Now subset the data for the desired columns.
subsetnames <- c("subject", "activity", as.character(feature.names))
data.subset <- subset(data.full, select = subsetnames)


## Apply descriptive names to remaining columns.
# Rename column names, only values that I'm confident about are renamed - not sure about several of these and
# unable to find documentation in the readme file or the additional data on their website.
names(data.subset) <- gsub("Gyro", "Gryroscope", names(data.subset))
names(data.subset) <- gsub("Mag", "Magnitude", names(data.subset))
names(data.subset) <- gsub("Acc", "Acceleration", names(data.subset))

## Finally, output a tidy dataset containing averages per subject, activity, and feature.
# Require plyr for the aggreation work.
library(plyr)

data.tidy <- ddply(data.subset, c("subject", "activity"), numcolwise(mean))
write.table(data.tidy, file = "./data/UCI Har Data Tidy.txt")