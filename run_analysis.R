##################################################
#The following code reads in data from experiments done on
#wearable computers and cleans and summarizes these data for analysis

require(dplyr)
require(magrittr)

#download data
ProjectUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(ProjectUrl,"Wearable.zip")
unzip("Wearable.zip")

#set up filepaths
dataPath <- file.path("UCI HAR Dataset")
testPath <- file.path(dataPath,"test")
trainPath <- file.path(dataPath,"train")

#pull in activity labels and features
activities <- read.table(file.path(dataPath,"activity_labels.txt"))
names(activities) <- c("activityLabel","activity")
features <- read.table(file.path(dataPath,"features.txt"))
names(features) <- c("index","feature")


#set up training data

trainsubjectID <- read.table(file.path(trainPath,"subject_train.txt"))
names(trainsubjectID) <- "subjectID"

trainData <- read.table(file.path(trainPath,"X_train.txt"))
names(trainData) <- features$feature
names(trainData) <- gsub("[-()]","",names(trainData))
trainData <- trainData[grepl("mean|std",names(trainData))]
trainData <- trainData[!grepl("Freq",names(trainData))]

trainActivities <- read.table(file.path(trainPath,"y_train.txt"))
names(trainActivities) <- "Activity"

trainingData <- cbind(trainsubjectID,trainActivities,trainData)
trainingData$status <- "train"

#set up test data

testsubjectID <- read.table(file.path(testPath,"subject_test.txt"))
names(testsubjectID) <- "subjectID"

testData <- read.table(file.path(testPath,"X_test.txt"))
names(testData) <- features$feature
names(testData) <- gsub("[-()]","",names(testData))
testData <- testData[grepl("mean|std",names(testData))]
testData <- testData[!grepl("Freq",names(testData))]


testActivities <- read.table(file.path(testPath,"y_test.txt"))
names(testActivities) <- "Activity"

testingData <- cbind(testsubjectID,testActivities,testData)
testingData$status <- "test"

#merge training and testing data

totalData <- rbind(trainingData,testingData)
totalData <- merge(totalData, activities, by.x="Activity",by.y="activityLabel")
totalData$Activity <- NULL

#write out the tidy data
write.csv(totalData,"alldata.csv",replace=TRUE)

#summarize data by experiment participant and activity
summedData <- totalData[!grepl("std",names(totalData))]
summedData$status <- NULL
summedData$KeyID <- paste(summedData$subjectID,summedData$activity,sep="-")
remergeKey <- summedData[names(summedData) %in% c("subjectID","activity","KeyID")]
remergeKey <- unique(remergeKey)
summedData$subjectID <- NULL
summedData$activity <- NULL

sumData <- summedData %>% group_by(KeyID) %>% summarise_each(funs(mean))
names(sumData) <- paste(names(sumData),"average", sep="_")
sumData <- merge(remergeKey, sumData, by.x="KeyID",by.y="KeyID_average")
sumData$KeyID <- NULL

#write out the summarized data
write.csv(sumData,"datasummarized.csv",replace=TRUE)
