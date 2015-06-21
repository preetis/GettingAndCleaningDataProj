#---------------------------------------------------------------------------------------------------------
#FINAL PROJECT - Getting and Cleaning Data 
##Aim of the project:
##--Demonstrate ability to collect, work with, and clean a data set which will be used to prepare tidy data for later analysis

##Assumptions:
##--The script assumes data is downloaded, unzipped and present in directory- "~/coursera/Getting and Cleaning Data/Project/UCI HAR Dataset"

##Primary Objectives:
##--Part 1- Merges the training and the test sets to create one data set
##--Part 2- Extracts only the measurements on the mean and standard deviation for each measurement
##--Part 3- Uses descriptive activity names to name the activities in the data set
##--Part 4- Appropriately labels the data set with descriptive variable names
##--Part 5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#---------------------------------------------------------------------------------------------------------


##Detailed description of the code :

#---------------------------------------------------------------------------------------------------------
#Part 1- Merges the training and the test sets to create one data set
#--Read metadata information, training datasets and test datasets from the downloaded data files
#--Merge train and test dataset to form one dataset along with metadata information used to update column names of combined dataset
##--Dataset created as result of this merge is : codebook- codebook_Part1.txt
#---------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------
#Part 2- Extracts only the measurements on the mean and standard deviation for each activity measured
#Assumption: meanFreq() is not part of this computation
#--Retrieve only the subject, activity details along with mean and standard measurements related columns from dataset in Part 1
#---------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------
#Part 3- Uses descriptive activity names to name the activities in the data set
#--Join the dataset obtained in Part 2 with the metadata information related to 'Activity' to retrieve Activity Name 
#--Drop ActivityID column from the dataset as post inclusion of Activity Name, it is just redundant information 
#---------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------
#Part 4- Appropriately labels the data set with descriptive variable names
#--All variables have been named appropriately in Part 1 based on the metadata files provided
#--The names are not being changed from what is available in features.txt file to enable easier joins with other datafiles if available
#---------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------
#Part 5- From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject
#--Compute aggregate of each measurement for each activity and each subject and remove the metadata information of DatasetType
##--Dataset created as result of this merge is : codebook- codebook_Part5.txt
#--Write the aggregated output dataset to a file without header information as per the instructions on the project
#---------------------------------------------------------------------------------------------------------
 
