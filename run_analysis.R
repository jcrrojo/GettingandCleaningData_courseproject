### 0. Download

URLdata <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(URLdata, temp, method = "curl")

#Unzip Train and Test
dataTrain <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
dataTest <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
dim(dataTrain)
dim(dataTest)
#dataTrain has 561 cols and 7352 rows
#dataTest has 561 cols and 2947 rows

#Unzip lab, subject, Inert
labTrain <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
labTest <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
subjectTrain <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
subjectTest <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
InertSxTrain <- read.table(unz(temp, "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"))
InertSyTrain <- read.table(unz(temp, "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"))
InertSzTrain <- read.table(unz(temp, "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"))
InertSBaccTrain <- read.table(unz(temp, "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt"))
InertSBgyroTrain <- read.table(unz(temp, "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"))
InertSxTest <- read.table(unz(temp, "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"))
InertSyTest <- read.table(unz(temp, "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"))
InertSzTest <- read.table(unz(temp, "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"))
InertSBaccTest <- read.table(unz(temp, "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"))
InertSBgyroTest <- read.table(unz(temp, "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"))

### 1. Merges the training an the test sets to create one data set

#Summary 
dim(subjectTrain)
dim(subjectTest)
dim(InertSxTrain)
dim(InertSyTrain)
dim(InertSzTrain)
dim(InertSxTest)
dim(InertSyTest)
dim(InertSzTest)
dim(InertSBaccTrain)
dim(InertSBaccTest)
dim(InertSBgyroTrain)
dim(InertSBgyroTest)

#library
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)

#Create variable dataSet and merge dataTrain and dataTest 
dataTrain <- mutate(dataTrain, dataSet = "Train")
dataTest <- mutate(dataTest, dataSet = "Test")
dataTT <- bind_rows (dataTrain, dataTest)

#Summary
str(dataTT)
dim(dataTT)
dim(dataTrain)
dim(dataTest)
table(dataTT$dataSet)

### 2. Extracts only the measurements on the mean and standard deviation 
#for each measurement
### 4. Appropriately labels the data set with descriptive variable names
# Attention!!! We reverse the process under sections 2 and 4, 
#to facilitate the selection of variables using the names of them, 
#using the "contains ()". 
#These names are indicative of contents of variables, 
#as required by section 3

features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
str(features)

install.packages("httr")
library(httr)

features1 <- mutate(features, lab = paste(V1, V2))
str(features1)
features2 <- select(features1, lab)
str(features2)

names(dataTT) <- features2$lab
str(dataTT)

dataTTred <- select(dataTT, contains("-std()"), contains("-mean()"), dataSet)
str(dataTTred)

### 3. Uses descriptive activity names to name the activities in the data set
labTT <- bind_rows (labTrain, labTest)
namesact <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING",
"STANDING", "LAYING")

#From rows to columns
labTT1 <- spread(labTT, V1, V1)
#Colnames
colnames(labTT1) <- namesact
#From columns to rows
labTT2 <- gather(labTT1, "activ", na.rm = TRUE)
#Summary
str(labTT2)
table(labTT2$activ)
table(labTT$V1)

#Join
dataTTred$join = row.names(dataTTred)
labTT2$join = row.names(labTT2)
dataTTredlab <- full_join(dataTTred, labTT2, by="join")
dim(dataTTredlab)
str(dataTTredlab)

### 5. From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable 
#for each activity and each subject.

##The data set is dataTTredlab, but it is not included the subject
subjectTT <- bind_rows (subjectTrain, subjectTest)

#Summary
str(subjectTT)
table(subjectTT$V1)

#Join
subjectTT$join = row.names(subjectTT)
dataTTredlabsubj <- full_join(dataTTredlab, subjectTT, by="join")
colnames(dataTTredlabsubj)
dataTTredlabsubj <- mutate(dataTTredlabsubj, subject = as.factor(V1))
dim(dataTTredlabsubj)
str(dataTTredlabsubj)
dataTTredlabsubj <- select(dataTTredlabsubj, -V1)

#the result using data.table
library(data.table)
tidyDataTT <- data.table(dataTTredlabsubj)
tidyDataTT <- select(tidyDataTT, -join, -value)
#using aggregate
tidyDataTT <- aggregate(. ~subject + activ, tidyDataTT, mean)
head(tidyDataTT)
#write file
write.table(tidyDataTT, file = "tidyDataTT.txt", row.names = FALSE)

