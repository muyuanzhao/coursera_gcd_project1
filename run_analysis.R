#setwd to location of files.  currently in same dir as this script
#setwd('~/coding/R/coursera/getting_and_cleaning_data/project_1/coursera_gcd_project1')

#test data
test_subject <- read.table('subject_test.txt')
names(test_subject) <- "subject"

test_y <- read.table('y_test.txt')
names(test_y) <- "activity"

test_x <- read.table('X_test.txt')

test_combo <- cbind(test_subject, test_y, test_x)

#training data
train_subject <- read.table('subject_train.txt')
names(train_subject) <- "subject"

train_y <- read.table('y_train.txt')
names(train_y) <- "activity"

train_x <- read.table('X_train.txt')

train_combo <- cbind(train_subject, train_y, train_x)

#combine data sets
combo <- rbind(test_combo, train_combo)

#extract mean and std columns - Add 2 to result to skip initial columns
features <- read.table('features.txt', stringsAsFactors=FALSE)
names(features) <- c('id', 'feature')
filtered_cols <- which(grepl('mean|std', features$feature)) + 2

filtered <- combo[,c(1,2,filtered_cols)]

#assign names to cols
filtered_cols <- features[grep('mean|std', features$feature),2]
filtered_cols <- c(head(names(combo), 2), filtered_cols)
names(filtered) <- filtered_cols

#set activity labels
activities <- read.table('activity_labels.txt', col.names=c('activity_code', 'activity_name'))
filtered$activity <- factor(filtered$activity, 
                            levels=activities[,1],
                            labels=activities[,2])

#export tidy data set
tidy_data_set <- aggregate(filtered, by=list(filtered$subject, filtered$activity), FUN=mean)
tidy_data_set <- tidy_data_set[,-3:-4] #for some reason last step duplicates first 2 cols
names(tidy_data_set) <- names(filtered)

write.table(tidy_data_set, file="tidy_data_set.txt", sep="\t", row.names=F)

