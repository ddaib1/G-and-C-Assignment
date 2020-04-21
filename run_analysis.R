setwd("C:/Users/ddaib/OneDrive/Documents/R/") #replace as required

#Loading libraries
library(dplyr)

#Reading training sets
X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/Y_train.txt")
Sub_train <- read.table("./train/subject_train.txt")

#Reading testing sets
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/Y_test.txt")
Sub_test <- read.table("./test/subject_test.txt")

#Read activity labels data
features <- read.table("./features.txt")
activityLabels <- read.table("./activity_labels.txt")

#Merging training and testing sets together
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

#Extracts the measurements of mean and standard deviation for each measurement
sel_features <- features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
X_total <- X_total[,sel_features[,1]]

#Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activityLabels[,2]))
activitylabel <- Y_total[,-1]

#Appropriately labels the data set with descriptive variable names
colnames(X_total) <- features[sel_features[,1],2]

#Creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
