Code Book - Tidy Data Set Project
===================================

This is the code book for tidy_data_set.txt, which is a cleaned up, aggregated version of the UCI HAR data set.  This file can be duplicated by using the run_analysis.R script and the necessary UCI HAR files (listed below).  Information for this data set can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The UCI HAR files required for this analysis include:
* X_train.txt
* X_test.txt
* y_train.txt
* y_test.txt
* subject_test.txt
* subject_train.txt
* activity_labels.txt
* features.txt

There are many variables in the final tidy_data_set.txt file.  The 'subject' field contains the identifier for the person participating in the study.  The 'activity' field contains the description of the activity being performed by the subject.  The descriptions of the remaining fields can be found in the features.txt file.  

The run_analysis.R script performs several major activities which are described below.

Combining Data
---------------------------

First data from X_test.txt, y_test.txt, and subject_test.txt are extracted into data frames, and then combined into a single data frame using cbind().  The same thing is done with X_train.txt, y_train.txt, and subject_train.txt.  

After we assemble the testing and training data sets into separate data frames, we combine these into a single data frame called 'combo' using rbind().

Filtering Data
---------------------------
To comply with the instructions of the project, we then filter out of 'combo' all columns that are not mean or standard deviation type measurements.  

To do this we first extract the data from features.txt into a data frame.  The first column of this file contains the number of the corresponding field in the X_train.txt and X_test.txt files.  Next, we filter out all the features/rows not matching the regular expression pattern 'mean|std' using `filtered_cols <- which(grepl('mean|std', features$feature))` .  We use the values of the remaining records to subset the columns from the 'combo' dataset into a new data frame called 'filtered'.  

Once the 'combo' data has been filtered we use similar logic to extract the feature descriptions, and assign these as names in the corresponding fields in the filtered data frame using the code below:

    filtered_cols <- features[grep('mean|std', features$feature),2]
    filtered_cols <- c(head(names(combo), 2), filtered_cols)
    names(filtered) <- filtered_cols

Setting Activity Labels
---------------------------------
Our tidy data set needs to include the activity names/descriptions instead of their numeric codes.  We do this be extracting the data from the activity_labels.txt file into a data frame.  Then we convert the 'activity' column in our filtered data frame to a factor defined by the numeric codes and lables in this 'activities' data frame.  This code can be seen below:

    activities <- read.table('activity_labels.txt', col.names=c('activity_code', 'activity_name'))
    filtered$activity <- factor(filtered$activity, 
                            levels=activities[,1],
                            labels=activities[,2])

Final Aggregation and Writing to file
-----------------------------------------------
As stated in the project instructions, we compute the average of each measurement (found in the 'X' files).  We group this aggregation by subject and activity name with the code below:

    tidy_data_set <- aggregate(filtered, by=list(filtered$subject, filtered$activity), FUN=mean) 

After this our tidy data set is completed, and we write it out to a tab delimited text file using `write.table(tidy_data_set, file="tidy_data_set.txt", sep="\t", row.names=F)`.
