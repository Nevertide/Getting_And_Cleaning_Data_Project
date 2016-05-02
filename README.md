# Coursera Data Science Speclization: Getting and Cleaning Data, Week 4 Project

## Project Goals:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps to Completion
1. Download run_analysis.R to the desired directory.
2. Execute run_analysis.R.
3. The script will create a ./data directory if one does not exist.
  + The script will then download the necessary zip file containing the raw data into this directory.
4. The script will merge the necessary data files, rename variables, and distribute a tidy dataset containing average values for each feature by subject and activity.
  + This dataset will also be exported to the ./data directory.
  
## Dependencies
* This script requires the ```plry``` library to produce the final summarized dataset.
