#Loading the Required Library's
library(dplyr)
library(data.table)

setwd("C:/Users/lakna/OneDrive/Desktop/Online Courses/Coursera- Getting and Cleaning Data/Peer-graded-Assignment-Getting-and-Cleaning-Data") #Set your working directory

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","temp.zip")

unzip("temp.zip")



features <- fread("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
#Training Data
subject_train <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Testing Data
subject_test <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "code")



#Merging the Training and Test Data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
merged_data <- cbind(Subject, Y, X)


TidyData <- merged_data %>% select(subject, code, contains("mean"), contains("std"))


TidyData$code <- activities[TidyData$code, 2]

#Adding the approprate column label to the tidy dataset

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)