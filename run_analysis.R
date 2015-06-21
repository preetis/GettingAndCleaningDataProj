#---------------------------------------------------------------------------------------------------------
#FINAL PROJECT - Getting and Cleaning Data 
##Aim of the project:
##--Demonstrate ability to collect, work with, and clean a data set which will be used to prepare tidy data for later analysis

##Assumptions:
##--The script assumes data is downloaded, unzipped and present in directory- "~/coursera/Getting and Cleaning Data/Project/UCI HAR Dataset"

##Objectives:
##--Part 1- Merges the training and the test sets to create one data set
##--Part 2- Extracts only the measurements on the mean and standard deviation for each measurement
##--Part 3- Uses descriptive activity names to name the activities in the data set
##--Part 4- Appropriately labels the data set with descriptive variable names
##--Part 5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#---------------------------------------------------------------------------------------------------------

#Remove any temporary variables in the workspace before starting the tidy data creation process
rm(list=ls())

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd("~/coursera/Getting and Cleaning Data/Project/UCI HAR Dataset");

#Include required libraries
library(plyr)
library(dplyr)

#---------------------------------------------------------------------------------------------------------
#Part 1- Merges the training and the test sets to create one data set
#---------------------------------------------------------------------------------------------------------
#1.1) Read metadata information from the downloaded data files
##1.1.1) Reads list of variables representing measurements recorded for each activity in training and test dataset
features=read.table('./features.txt',header=FALSE);
##1.1.2) Reads available activity names for which measurements are recorded in training and test dataset
activityType = read.table('./activity_labels.txt',header=FALSE);

#1.2) Read training datasets from the downloaded data files
##1.2.1) Reads subject(user) details who performed the activity details captured in x_train.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE);
##1.2.2) Reads activity details for each subject identified in subject_train.txt
xTrain = read.table('./train/x_train.txt',header=FALSE);
##1.2.3) Reads activity type information for each activity captured in x_train.txt
yTrain = read.table('./train/y_train.txt',header=FALSE);

#1.3) Read test datasets from the downloaded data files
##1.3.1) Reads subject(user) details who performed the activity details captured in x_test.txt
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
##1.3.2) Reads activity details for each subject identified in subject_test.txt
xTest = read.table('./test/x_test.txt',header=FALSE);
#Reads activity type information for each activity captured in x_test.txt
yTest = read.table('./test/y_test.txt',header=FALSE); 

#1.4) Rename column names for each of the datasets read in Step 1.2 and 1.3 to more descriptive names
names(features) <- c("FeatureID","FeatureName")
names(activityType) <- c("ActivityID","ActivityName")
names(subjectTrain) <- c("SubjectID")
names(subjectTest) <- c("SubjectID")
names(xTrain) <- features$FeatureName
names(xTest) <- features$FeatureName
names(yTrain) <- c("ActivityID")
names(yTest) <- c("ActivityID")

#1.5) Combine all files for Train set and include a variable datasetType to identify that the data corresponds to Training set
trainDataset <- cbind(subjectTrain, yTrain, xTrain, DatasetType="Train")

#1.6) Combine all files for Test set and include a variable datasetType to identify that the data corresponds to Test set
testDataset <- cbind(subjectTest, yTest, xTest, DatasetType="Test")

#1.7) Merge train and test dataset to form one dataset
trainTestDataset <- rbind(trainDataset, testDataset)

#---------------------------------------------------------------------------------------------------------
#Part 2- Extracts only the measurements on the mean and standard deviation for each activity measured
#Assumption: meanFreq() is not part of this computation
#---------------------------------------------------------------------------------------------------------
#2.1) Compute logical vector to retrieve TRUE for all column indexes where :
#        --column name matches- SubjectID, ActivityID, DatasetType, mean(), std() 
colsToExtract <- c(grepl("SubjectID", names(trainTestDataset),fixed=TRUE) |     #Retrieve TRUE for column index where name is like SubjectID
                   grepl("ActivityID", names(trainTestDataset),fixed=TRUE) |    #Retrieve TRUE for column index where name is like ActivityID
                   grepl("mean()", names(trainTestDataset),fixed=TRUE) |        #Retrieve TRUE for column index where name is like mean()
                   grepl("std()", names(trainTestDataset),fixed=TRUE) |         #Retrieve TRUE for column index where name is like std()
                   grepl("DatasetType", names(trainTestDataset),fixed=TRUE))    #Retrieve TRUE for column index where name is like DatasetType

#2.2) Subset the computed dataset in Part 1 to include only the subject, activity details along with mean and standard measurements only
meanStdDataset <- trainTestDataset[colsToExtract]

#---------------------------------------------------------------------------------------------------------
#Part 3- Uses descriptive activity names to name the activities in the data set
#---------------------------------------------------------------------------------------------------------
#3.1) Join the dataset obtained in Part 2 with the metadata information related to 'Activity' to retrieve Activity Name based on 'ActivityID'
meanStdAtvyDataset <- join(meanStdDataset,activityType,type="full", match="all")

#3.2) Rearrange the dataset columns to drop ActivityID (since ActivityName is included) and 
#contain cols in order:- SubjectID, ActivityID, DatasetType, 
#mean related measurements, and std. deviation related measurements
colsOrdered <- c(grep("SubjectID", names(meanStdAtvyDataset),fixed=TRUE),
                           grep("ActivityName", names(meanStdAtvyDataset),fixed=TRUE),
                           grep("DatasetType", names(meanStdAtvyDataset),fixed=TRUE),
                           grep("mean()", names(meanStdAtvyDataset),fixed=TRUE),
                           grep("std()", names(meanStdAtvyDataset),fixed=TRUE));
subAtvyMeanStdDataset <- meanStdAtvyDataset[,colsOrdered];

#---------------------------------------------------------------------------------------------------------
#Part 4- Appropriately labels the data set with descriptive variable names
#---------------------------------------------------------------------------------------------------------
#All variables have been named appropriately in Part 1 based on the metadata files provided
#The names are not being changed from what is available in features.txt file to enable easier joins with other datafiles if available
# Dataset available at the end of Step 4- subAtvyMeanStdDataset

#---------------------------------------------------------------------------------------------------------
#Part 5- From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject
#---------------------------------------------------------------------------------------------------------
#Compute aggregate of each measurement for each activity and each subject and remove the metadata information of DatasetType
aggSubjAtvy<- aggregate(select(subAtvyMeanStdDataset, -(SubjectID:DatasetType)),by=list(ActivityName=subAtvyMeanStdDataset$ActivityName, SubjectID=subAtvyMeanStdDataset$SubjectID),mean);

#Write the output dataset to a file with row.names as FALSE as per the instructions on the project
write.table(aggSubjAtvy,'./TidyAggDataAtActiviySubjectLevel.txt',row.names=FALSE,sep='\t');

 
