# Getting_and_Cleaning_Data_Course_Project



# Here, I have created the run_analysis.R script to: 

1. Read into R the data that was downloaded for the course project.

2. Merge the training and the test sets to create one data set.

3. Extract only the measurements on the mean and standard deviation for each measurement.

4. Use descriptive activity names to name the activities in the data set.

5. Appropriately label the data set with descriptive variable names.

6. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

7. Output the tidy data set as a text file named tidy_dataset.txt



# The files included in this submission:

1. run_analysis.R — Script for processing data and outputting tidy dataset.

2. CodeBook.md — Document that describes the variables in the tidy dataset, a brief description of the data, and the work performed to clean up the data.

3. tidy_dataset.txt — The resultant tidy dataset.

4. README.md — Outline of analysis done and list of file.



# Instructions for producing the tidy dataset using my script:

1. First download the data for the course project from here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. In the run_analysis.R script file, set the directory location (replace the default text I have written) of where the course project data is located and where you want the tidy dataset to be written out.

3. Copy all the text in the run_analysis.R file and click run in Rstudio or call run_analysis.R directly in the terminal.
