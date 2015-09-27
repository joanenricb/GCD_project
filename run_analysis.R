library(dplyr)

get_feature_names <- function() {
    features <- read.table("./UCI\ HAR\ Dataset/features.txt", col.names = c("id", "feature"))
    return(filter_mean_std(features))
}

filter_mean_std <- function(all_features){
    ## Extracts only the measurements on the mean and standard deviation for each measurement
    filtered_features <- all_features[grep("mean\\(\\)|std\\(\\)", all_features$feature),]
}

get_df <- function(type, name) {
    df <- read.table(paste("./UCI\ HAR\ Dataset/", type, "/", name, "_", type, ".txt", sep = ""),
                     check.names=FALSE)
    return(df)
}

get_df_with_features <- function(type, name) {
    df <- get_df(type, name)
    df <- df[,features$id]
    names(df) <- features$feature
    return(df)
}

## Download the data to workspace for the first time

if(!file.exists("./UCI\ HAR\ Dataset")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  "UCI-HAR-Dataset.zip", method = "curl")
    unzip("UCI-HAR-Dataset.zip")
}
features <- get_feature_names()

## we do not want to read them every time :)
if(!"train_df" %in% ls()){train_df <- get_df_with_features("train", "X")}
if(!"test_df" %in% ls()){test_df <- get_df_with_features("test", "X")}

train_y <- get_df("train", "y")
test_y <- get_df("test", "y")
train_subject <- get_df("train", "subject")
test_subject <- get_df("test", "subject")

## Renaming columns
names(train_y) <- c("activity")
names(test_y) <- c("activity")
names(train_subject) <- c("subject")
names(test_subject) <- c("subject")

## Merge the training and the test sets to create one data set.
train <- cbind(train_subject, train_df, train_y)
test <- cbind(test_subject, test_df, test_y)
dataset <- rbind(train, test)

## create auxiliar column with subject + activity for aggregation.
## Note: aggregation in multiple columns with dplyr is not really supported
dataset$id <- paste(dataset$subject, dataset$activity)


## From the data set in step 4, creates a second, independent 
## tidy data set with the average of each variable for each activity and each subject.
result <- dataset %>% group_by(id) %>% summarise_each(funs(mean))

## Remove aux column for tidy dataset
result$id <- NULL

## write result
write.table(result, "tidy.txt", row.name=FALSE)



