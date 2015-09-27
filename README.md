# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script,  run_analysis.R , does the following:

* Loads the test & training datasets
* Load the activity, subject and feature info
* Merges the subject & activity dataframes with the test & trainings dataframes resp.
* Combine test & training datasets
* subsets the dataset to keeping only those columns which reflect a mean or standard deviation
* rename column names appropriately
* Creates a dataset that consists of the average (mean) value of each variable for each subject and activity pair.
* creates a final_tidy dataset which is in narrow form

The end result is shown in the file  final_tidy.txt .

final dataset can be read back in R using the following code
file<-read.table(file = "final_tidy.txt",header = TRUE)

dataset can be converted into a wide tidy dataset usineg code:
file1<-dcast(file,subject+activity_number+activity_name~variable)
