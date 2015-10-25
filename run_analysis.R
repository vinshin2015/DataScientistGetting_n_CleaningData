library(data.table)
setwd("D:/Coursera/Data Scientist/Getting and Cleaning Data/Data/Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

# Read all the column/Variable names for 561 variables
# Used the data.table package to read the table and then transpose(t) the table of 2 col 561 #observations to a table of 561 columns and 2 observations(rows)
rownames<-t(read.table("./features.txt"))

#Read the 6 Activities as a table with activity code and activity long name
activity<-read.table("./activity_labels.txt")

#Test data preparation
x_test<-read.table("./test/X_test.txt") 
#Assign column/Variable names
names(x_test)<-rownames[2,]
#Activities
y_test<-read.table("./test/y_test.txt")
#Join/Merge with Activity description/label.
y_test_activity<-merge(y_test,activity,by.x = "V1", by.y = "V1", all.x = TRUE)
names(y_test_activity)<-c("ActivityCd","ActivityLabel")
#Subjects
sub_test<-read.table("./test/subject_test.txt")
names(sub_test)<-c("Subject")

#Create a complete Test data set by ensuring that the subject,
#activity and the measuresments are combined
CompleteTestDataset<-cbind(sub_test,y_test_activity,x_test)

#Training data preparations
x_train<-read.table("./train/X_train.txt") 
names(x_train)<-rownames[2,]
#Activities
y_train<-read.table("./train/y_train.txt")
#Join/Merge with Activity description/label.
y_train_activity<-merge(y_train,activity,by.x = "V1", by.y = "V1", all.x = TRUE)
names(y_train_activity)<-c("ActivityCd","ActivityLabel")
#Subjects
sub_train<-read.table("./train/subject_train.txt")
names(sub_train)<-c("Subject")

#Create a complete Train data set by ensuring that the subject,
#activity and the measuresments are combined
CompleteTrainingDataset<-cbind(sub_train,y_train_activity,x_train)

#Trainign and Test combined
MergedTrainingTest<-rbind(CompleteTrainingDataset,CompleteTestDataset)

library(dplyr)
#subsetting the data set for mean and std values
TmpNames<-names(MergedTrainingTest)
#Finding indices of the columsn for mean and std deviations
MeanIndex<-grep("mean",TmpNames)
StdIndex<-grep("std",TmpNames)
#Creating a list of cols to retain
ColToRetain<-c(1,2,3,MeanIndex,StdIndex)
#subsetting the data frame to retain cols of intrest
SubMergedTrainingTest<-MergedTrainingTest[,ColToRetain]

#Calculating Mean
FinalAverages<-SubMergedTrainingTest %>% group_by(Subject,ActivityCd,ActivityLabel) %>% summarize_each(funs(mean))

# Write file
write.table(FinalAverages, file = "FinalAverages.txt", row.names = FALSE)

