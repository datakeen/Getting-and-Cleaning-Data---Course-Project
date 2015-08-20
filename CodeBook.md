

#CodeBook #
Purpose of this code book is to explain the data, variables, task requirement, and transformation approach.-


<h2>Data Source</h2>
The data was acquired from link given at course website : [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip)
<h2>Detail of Study/Experiment</h2>
There are 30 participants who volunteered to perform different activities in the study. These participants will called subjects. Each subject performed 6 activities and many different measurements were recorded during their performance.
The data consist of two subsets, namely *“train”* and *“test”* datasets.
Even in *“train”* and *“test”* directories, the data is scattered in different files. For a detailed description please see README.md file. 
Variables
There are 561 variables which were considered related to subject performance. Following are names of some of variables.

 - "tBodyAcc-mean()-X"                    
 - "tBodyAcc-mean()-Y"  
 - "tBodyAcc-mean()-Z"
 - "tBodyAcc-std()-X"
 -  "tBodyAcc-std()-Z"         
 - "tGravityAcc-mean()-Y"        
 - "tGravityAcc-mean()-Z"                
 -  "tGravityAcc-std()-X"

These names are made more readable by for example ”t” with “Time” or  “Acc” with "Accelerometer".
This is more elaborate in “run_analysis.R” script or later in this document.

<h2>Task Requirement</h2>

> Course website explains the course requirements in following words The
> purpose of this project is to demonstrate your ability to collect,
> work with, and clean a data set. The goal is to prepare tidy data that
> can be used for later analysis. You will be graded by your peers on a
> series of yes/no questions related to the project. You will be
> required to submit: 1) a tidy data set as described below, 2) a link
> to a Github repository with your script for performing the analysis,
> and 3) a code book that describes the variables, the data, and any
> transformations or work that you performed to clean up the data called
> CodeBook.md. You should also include a README.md in the repo with your
> scripts. This repo explains how all of the scripts work and how they
> are connected.

>…..

And 

> You should create one R script called run_analysis.R that does the following. 
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names. 
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

<h2>Data Transformation</h2>
<h3>Prerequisites and supposition</h3>
It is considered that all the data is available in a folder named “data” within the working directory.
R-Package “dplyr” is already installed on the system.
<h3>Data loading by R</h3>
Data is being upload by following R-commands

    #Cleaning global emvirimment by removing existing R objects
    remove(list=ls())
    library(dplyr)
    #Reading data files in Main 2 files
    df_f<-read.table("./data/features.txt")
    df_al<-read.table("./data/activity_labels.txt")
    
    #Reading the data files in "train" folder  (3 files)
    
    df_s_train<-read.table("./data/train/subject_train.txt")
    df_x_train<-read.table("./data/train/X_train.txt")
    df_y_train<-read.table("./data/train/y_train.txt")
    
    
    #---------------------------------------------------------------------------------------
    #Reading the data files in "test" folder  (3 files)
    
    df_s_test<-read.table("./data/test/subject_test.txt")
    df_x_test<-read.table("./data/test/X_test.txt")
    df_y_test<-read.table("./data/test/y_test.txt")

<h3>Task 1 – Merging and Training Datasets</h3>
Since “train” and “test” data are stored separately, I combined “train” data first and on the same lines I combined “train” data. After combining the both datasets were merged to fulfil the requirement of Task 1.
Merging the data available in different files follows following thematic diagram


![Thematic diagram for binding different parts of data together](https://lh3.googleusercontent.com/-jztiJAoFgJI/VdWJxhCIiJI/AAAAAAAAAr8/iBDn0IbzaU8/s600/Thematic+diagram+for+binding+different+parts+of+data+together..png "Thematic diagram for binding different parts of data together..png")

    #TRAIN
    #adding useful(descriptive) names to colunms of data frame "df_x_train" from list of features "df_f"
    names(df_x_train)<-df_f[,2]
    
    #Combining X_train, Y_train and subject_train datasets to a new dataframe "df_train_temp1"
    df_train_temp1<-bind_cols(df_s_train,df_y_train,df_x_train)
    
    
    #Assigning first column which shows subject identifire a  reasonable name "subject"
    names(df_train_temp1)[1:2]<-c("subject","activity")
    df_train_temp2<-bind_cols(data.frame("dataStatus"=rep("train",nrow(df_train_temp1)),df_train_temp1))
    #
    #
    #TEST
    #adding useful names to colunms of data frame "df_x_test" from list of features "df_f"
    names(df_x_test)<-df_f[,2]
    
    
    
    #Combining X_test, Y_test and subject_test datasets to a new dataframe "df_test_temp1"
    df_test_temp1<-bind_cols(df_s_test,df_y_test,df_x_test)
    
    
    #Assigning first column which shows subject identifire a  reasonable name "subject"
    names(df_test_temp1)[1:2]<-c("subject","activity")
    df_test_temp2<-bind_cols(data.frame("dataStatus"=rep("test",nrow(df_test_temp1)),df_test_temp1))
    
    # Step#1 Merging test and train datasets
    df_merged<-rbind(df_test_temp2,df_train_temp2)

<h3> Task 2 – Extracting only the mean and standard deviation for each measurement</h3>
From `df_merged` all columns which have term “std” or “mean” in their names were separated 

    # Step#2 Extracting only the mean and standard deviation for each measurement
    df_merged_extracted<-select(df_merged, dataStatus:activity, contains("mean"), contains("std"))

<h3>Task 3 – Use descriptive names to activities in dataset</h3>
Descriptive names are assigned as follows

    df_merged_extracted$activity<-factor(df_merged_extracted$activity,labels=df_al[,2])

<h3>Task 4 - Appropriately label the dataset with descriptive variable names</h3>
So far the data I have acquired is good but their names can be made even more descriptive by replacing short form of short form of words to proper words. For example “Acc” is changes to "Accelerometer". This convention is explained in README.md

    # Replacing difficult to understand pherases with understandable names
    variables<-names(df_merged_extracted)
    variables<-gsub("Acc", "Accelerometer", variables)
    variables<-gsub("Gyro", "Gyroscope", variables)
    variables<-gsub("BodyBody", "Body", variables)
    variables<-gsub("Mag", "Magnitude", variables)
    variables<-gsub("^t", "Time", variables)
    variables<-gsub("^f", "Frequency", variables)
    variables<-gsub("tBody", "TimeBody", variables)
    variables<-gsub("mean", "Mean", variables, ignore.case = F)
    variables<-gsub("std", "STD", variables, ignore.case = F)
    vvariables<-gsub("-freq()", "Frequency", variables, ignore.case = TRUE)
    variables<-gsub("angle", "Angle", variables)
    variables<-gsub("gravity", "Gravity", variables)
    variables<-gsub("()", "", variables, fixed=TRUE)
    
    # Changing variables names of our dataframe with modified names
    names(df_merged_extracted)<-variables

<h3>Task 5 - Create a second, independent tidy data set with the average of each variable for each activity and each subject.</h3>
This requirement is fulfilled with following code

    df_temp<-df_merged_extracted[,4:dim(df_merged_extracted)[2]]
    df_tidy<-aggregate(df_temp,list(df_merged_extracted$subject, df_merged_extracted$activity), mean)
    Task 5b - data set as a txt file created with write.table() for uploading
    df_temp<-df_merged_extracted[,4:dim(df_merged_extracted)[2]]
    df_tidy<-aggregate(df_temp,list(df_merged_extracted$subject, df_merged_extracted$activity), mean)
    # Activity and Subject name of columns 
    names(df_tidy)[1:2] <- c("Subject","activity")
    
    #Writing the data in file
    write.table(df_tidy, file = "TidyData.txt", row.names = FALSE)

