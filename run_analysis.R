#Load required libraries.
library(dplyr)
library(stringr)

#Set the directory to where files are located.
directory <- "/Users/brettaddison/Dropbox/Coursera_data_science/Getting_Cleaning_Data/Week4/project/UCI_HAR_Dataset/"
#Read in the test dataset first.
#Specify the name of the X_test file.
X_test_data_file <- paste0(directory, "test/X_test.txt")

#Read the X_test file into a data frame called X_test.
X_test <- read.table(X_test_data_file)

#Specify the name of the y_test file.
y_test_data_file <- paste0(directory, "test/y_test.txt")

#Read the y_test file into a data frame called y_test.
y_test <- read.table(y_test_data_file)

#Specify the name of the subject test file and read it into a data frame called subject_test.
subject_test_file <- paste0(directory, "test/subject_test.txt")
subject_test <- read.table(subject_test_file)

#Read in the train dataset.
#Specify the name of the X_train file.
X_train_data_file <- paste0(directory, "train/X_train.txt")

#Read the X_train file into a data frame called X_train.
X_train <- read.table(X_train_data_file)

#Specify the name of the y_train file.
y_train_data_file <- paste0(directory, "train/y_train.txt")

#Read the y_train file into a data frame called y_train.
y_train <- read.table(y_train_data_file)

#Specify the name of the subject train file and read it into a data frame called subject_train.
subject_train_file <- paste0(directory, "train/subject_train.txt")
subject_train <- read.table(subject_train_file)

#Merge the test and train datasets.
merged_X_test_train <- rbind(X_test, X_train)

#Merge the subject test and train datasets.
merged_subject_test_train <- rbind(subject_test, subject_train)

#Rename variable name.
merged_subject_test_train <- rename(merged_subject_test_train, subject.id = V1)

#Merge the y test and train datasets.
merged_y_test_train <- rbind(y_test, y_train)

#Rename variable name.
merged_y_test_train <- rename(merged_y_test_train, activity = V1)

#Create one dataset by merging merged_subject_test_train, merged_y_test_train, and merged_X_test_train.
merged_dataset <- cbind(merged_subject_test_train, merged_y_test_train, merged_X_test_train)

#Use the features.txt file to determine which columns to extract. Look for the words mean() and std().
features_file <- paste0(directory, "features.txt")
features <- read.table(features_file)

#Extract the columns from features that contain the words mean() and std().
mean_std_features <- grep('mean()|std()', features$V2, value = FALSE)

#Remove meanFreq() from list.
remove <- grep('meanFreq()', features$V2, value = FALSE)
mean_std_features <- setdiff(mean_std_features, remove)

#Extract the appropriate columns in the merged_dataset using the mean_std_features
#vector to indicate which columns to extract.
merged_dataset_mean_std <- cbind(merged_subject_test_train, merged_y_test_train, merged_X_test_train[,mean_std_features])

#Use the activity_labels.txt file to change the activity index number to the actual activity name.
activity_labels_file <- paste0(directory, "activity_labels.txt")
activity_labels <- read.table(activity_labels_file)
#merged_dataset_mean_std2 <- merged_dataset_mean_std
index <- c(1:nrow(merged_dataset_mean_std))
merged_dataset_mean_std$activity <- activity_labels$V2[merged_dataset_mean_std$activity[index]]

#Extract the column names from the features file.
merged_dataset_column_names <- features$V2[mean_std_features]
#Change the first t letter in column names to time.
merged_dataset_column_names <- sub('^t', 'time', merged_dataset_column_names)
#Change the first f letter in column names to frequency.
merged_dataset_column_names <- sub('^f', 'frequency', merged_dataset_column_names)
#Replace uppercase letter with a period and lower case letter.
merged_dataset_column_names <- gsub('([[:upper:]])', '.\\L\\1', merged_dataset_column_names, perl = TRUE)
#Replace acc with accelerometer.
merged_dataset_column_names <- sub('acc', 'accelerometer', merged_dataset_column_names)
#Replace gyro with gyroscope.
merged_dataset_column_names <- sub('gyro', 'gyroscope', merged_dataset_column_names)
#Replace - with period in column names.
merged_dataset_column_names <- sub('-', '.', merged_dataset_column_names)
#Remove () in column names.
merged_dataset_column_names <- sub('\\()', '', merged_dataset_column_names)
#Remove - in column names.
merged_dataset_column_names <- sub('-', '', merged_dataset_column_names)

#Now set the column names in the merged_dataset_mean_std to merged_dataset_column_names.
colnames(merged_dataset_mean_std)[3:ncol(merged_dataset_mean_std)] <- merged_dataset_column_names

#First group the dataset by subjects and then by activities. arrange(merged_dataset_mean_std, subject.id, activity)
grouped_subj_act_dataset_mean_std <- merged_dataset_mean_std %>% group_by(subject.id, activity)

#Determine the mean for each subject-activity pair.
tidy_merged_dataset_avg <- grouped_subj_act_dataset_mean_std %>% summarize_each(funs(mean))

#Write out the tidy dataset to a txt file.
output_file <- paste0(directory, "tidy_dataset.txt")
write.table(tidy_merged_dataset_avg, file = output_file, sep = " ", row.names = FALSE, col.names = TRUE)