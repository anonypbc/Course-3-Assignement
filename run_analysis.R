library("dplyr")
library("data.table")
setwd("D:\\OneDrive - nqgs\\Documents\\Testing_R")
unzip("getdata_projectfiles_UCI HAR Dataset.zip")
setwd("D:\\OneDrive - nqgs\\Documents\\Testing_R\\UCI HAR Dataset")
path = "D:\\OneDrive - nqgs\\Documents\\Testing_R\\UCI HAR Dataset"
activities <- fread(file.path(path,"activity_labels.txt"), 
                    col.names = c("n", "activities"))
feature <- fread(file.path(path,"features.txt"), 
                 col.names = c("num", "func"))
#load the data in test set 
x_test <- fread(file.path(path,"test\\X_test.txt"), 
                col.names =feature$func)
sub_test <- fread(file.path(path, "test\\subject_test.txt"), col.names = "subject")
y_test <- fread(file.path(path, "test\\y_test.txt"), 
                col.names = "activities")
test <- cbind(y_test, sub_test, x_test)
#load the data in train set
y_train <- fread(file.path(path,"train\\y_train.txt"),
                 col.names = "activities")
x_train <- fread(file.path(path,"train\\X_train.txt"),
                 col.names = feature$func)
sub_train <- fread(file.path(path, "train\\subject_train.txt"), col.names = "subject")
train <- cbind(y_train, sub_train, x_train)
#bind to data
final <- rbind(test, train)
new <- final %>% select(1,2,contains("mean()"), contains("std()"))
names(new) <- gsub("-mean()", "Mean", names(new), ignore.case = TRUE)
names(new) <- gsub("^t", "Time", names(new))
names(new) <- gsub("^f", "Frequency", names(new))
names(new) <- gsub("BodyBody", "Body", names(new))
names(new) <- gsub("Acc", "Accelerometer", names(new))
names(new) <- gsub("-std()", "STD", names(new))
names(new) <- gsub("Gyro", "Gyroscope", names(new))
names(new) <- gsub("Mag", "Magnitude", names(new))
names(new) <- gsub("subject", "Subject", names(new))
names(new) <- gsub("activities", "Activities", names(new))


result <- new %>% group_by(Subject, Activities) %>% summarise_all(funs(mean))

write.table(result, "finalData.txt", row.names = FALSE)
