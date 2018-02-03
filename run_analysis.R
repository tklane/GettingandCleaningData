library(tidyverse)
library(readr)


# Merge the training and the test sets to create one data set.

# read the features to label the columns
collabels<- read_table("features.txt", col_names = FALSE)
collabels<-collabels %>% separate(X1,c("Feature ID", "Feature"), sep = " ")

#load the training data set
train<-read_table("./train/X_train.txt", col_names=FALSE)

#rename column names to features
colnames(train) <- collabels$Feature

#read in subject data and add to train data frame
subjects <- read_table("./train/subject_train.txt", col_names=FALSE)
colnames(subjects) <- "Subject"
train <- train %>% add_column("Subject" = subjects$Subject)

#load the label activities and add to train data frame
activities <- read_table("./train/y_train.txt",col_names=FALSE)
colnames(activities) <- "Activity"
# Uses descriptive activity names to name the activities in the data set
activities <- activities %>% add_column('Label' = recode(activities$Activity, `1` = "Walking",  `2` = "Walking Upstairs",  `3` = "Walking Downstairs",  `4` = "Sitting",  `5` = "Standing",  `6` = "Laying"))
train <- train %>% add_column("Activity Type" = activities$Label)

#load the testing data set
test<-read_table("./test/X_test.txt", col_names=FALSE)

#rename column names to features
colnames(test) <- collabels$Feature

#read in subject data and add to test data frame
subjects <- read_table("./test/subject_test.txt", col_names=FALSE)
colnames(subjects) <- "Subject"
test <- test %>% add_column("Subject" = subjects$Subject)

#load the label activities and add to test data frame
activities <- read_table("./test/y_test.txt",col_names=FALSE)
colnames(activities) <- "Activity"
# Uses descriptive activity names to name the activities in the data set
activities <- activities %>% add_column('Label' = recode(activities$Activity, `1` = "Walking",  `2` = "Walking Upstairs",  `3` = "Walking Downstairs",  `4` = "Sitting",  `5` = "Standing",  `6` = "Laying"))
test <- test %>% add_column("Activity Type" = activities$Label)

#join the test and training data sets

all<-bind_rows(test,train)

# Extracts only the measurements on the mean and standard deviation for each measurement, subjects and activity type.
tidy <- all %>% select(matches("*mean\\(\\)*|std\\(\\)*|Subject|Activity Type"))
write.csv(tidy,"tidy.csv")

# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

averagetidy <- tidy %>% group_by(`Activity Type`,Subject) %>% summarise_all(funs(mean))
write.csv(averagetidy,"averagetidy.csv")