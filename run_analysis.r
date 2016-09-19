#read train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE) 
set_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
labels_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)

#read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE) 
set_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
labels_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)

#read features data
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)

#read activites data
activities  <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)


#merge subjects
merged_subjects <- rbind(subject_train, subject_test)

#merge labels
merged_labels <- rbind(labels_train, labels_test)

#merge sets
merged_set <- rbind(set_train, set_test)

#assign column names
colnames(features) <- c("id", "feature")
colnames(activities) <- c("id","activity")

#named merged columns
colnames(merged_set) <- features$feature

#extract column names with mean and std
mean_std_cols <- names(merged_set)[grep("mean\\(\\)|std\\(\\)", names(merged_set))]

#keep extracted columns
merged_set <- merged_set[, mean_std_cols]

#remove parenthesis from column names
colnames(merged_set) <- sub("\\(\\)", "", names(merged_set))

#add columns "subject" "activity" to table
merged_set = cbind(subject = merged_subjects[, 1], activity = merged_labels[, 1], merged_set)

#add activity labels to the merged dataset
merged_set$activity <- apply(merged_set["activity"], 1, function(x) activities[x, 2])

#aggregate and calculate mean by subject and activity
tidy <- aggregate(. ~ subject + activity, data = merged_set, mean)

#save the tidy dataset to file
write.table(tidy, "tidy_data.txt", sep = "\t", col.names = T, row.names = T, quote = T)