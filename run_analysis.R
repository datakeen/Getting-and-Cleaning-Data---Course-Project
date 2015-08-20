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

#PROCESSING DATA
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

# Step#2 Extracting only the mean and standard deviation for each measurement
df_merged_extracted<-select(df_merged, dataStatus:activity, contains("mean"), contains("std"))

# Step#3 Use descriptive names to activities in dataset:
df_merged_extracted$activity<-factor(df_merged_extracted$activity,labels=df_al[,2])

# Step#4 Appropriately label the dataset with descriptive variable names:
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
variables<-gsub("-freq()", "Frequency", variables, ignore.case = TRUE)
variables<-gsub("angle", "Angle", variables)
variables<-gsub("gravity", "Gravity", variables)
variables<-gsub("()", "", variables, fixed=TRUE)

# Changing variables names of our dataframe with modified names
names(df_merged_extracted)<-variables

# Step#5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
df_temp<-df_merged_extracted[,4:dim(df_merged_extracted)[2]]
df_tidy<-aggregate(df_temp,list(df_merged_extracted$subject, df_merged_extracted$activity), mean)

# Activity and Subject name of columns 
names(df_tidy)[1:2] <- c("Subject","activity")
#Writing the data in file
write.table(df_tidy, file = "MyTidyData.txt", row.names = FALSE)
