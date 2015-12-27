# GettingandCleaningData_courseproject
Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following. 
section 1. Merges the training and the test sets to create one data set.
section 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
section 3. Uses descriptive activity names to name the activities in the data set
section 4. Appropriately labels the data set with descriptive variable names. 
section 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Step 1. Download files and unzip dataTrain, dataTest, lab, subject, inert

###Step 2 (section 1). Merges the training and the testing sets to create one data set, using the packages "dplyr" andd "tidyr"

###Step 3 (sections 2, 4). We reverse the process under sections 2 and 4, to facilitate the selection of variables using the names of them, using the "contains ()". These names are indicative of contents of variables, as required by section 3. First, we using the names() and last using the package "httr", select with contains() only the measurements on the mean and standard deviation for each measurement.

###Step 4 (section 3). Use descriptive activity names to name the activities in the data set. Join labTrain and labTest, create a vector with activities names, use spread for extend rows to columns, use colnames and use gather for inverse process. Finaly, join activity and data set.

###Step 5 (section 5). The data set does not include the subject, so add subject. Using de package "data.table" and aggregate function, we made tidyDataTT with the average of each variable or each activity and each subject. Finaly, with write.table, made the final file: tidyDataTT.txt

###The whole code is in run_analysis.R

###The Code Book with description of variables is "UCI HAR Dataset.names.pdf"
