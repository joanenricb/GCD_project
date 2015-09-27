# Getting and Cleaning Data - Project

This repository contains the required activity to complete the project for Getting and Cleaning Data.
run_analysis.R performs the following activities

1. Downloads the dataset if it does not already in the working directory
2. Reads the names of the features
3. Loads the train and test data sets from ./UCI HAR Dataset/{train, test} and keep only the features corresponding to mean() and std() magnitudes
4. Loads the activity and subject data for each dataset
5. merges the training and the test sets to create one data set and combines it with the data.
6. Creates the requested tidy dataset. It contains the mean of each variable for each subject and activity pair.
7. writes the result in tidy.txt.