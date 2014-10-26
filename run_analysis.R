# The general approach is to tidy the Test Data first, then the Training Data, then to join the two into one single table/data frame. See README.md for more info

# Importing the Data ====

# instructions say that the Samsung data is in the current working directory but it isn't clear exactly what that means: the current wd contains the full data folder; or is the current wd the root dir of the full data folder (i.e. has the four .txt files + the test and train subdirs)?? This is a way to overcome the ambiguity:-
samsungDir <- choose.dir(caption="Please choose the folder holding the Samsung Test data")
dataDir <- read.table(file = paste(samsungDir, "\\activity_labels.txt", sep=""), header = FALSE)
# dataDir could now be used in the filenames below
# I haven't implemented this for now; have just proceeded on the basis that the getwd() contains a folder called UCI_HAR_Dataset which contains the Samsung data ...

# Features, Activites Data ====

# import features (data = tBodyAcc-XYZ etc); and tidy
features <- read.table(file = "./UCI_HAR_Dataset/features.txt", header = FALSE)
features <- features[,2] # eliminate rownames 1, 2, 3, ...

# import activities (data =  WALKING, STANDING etc); and tidy
activities <- read.table(file = "./UCI_HAR_Dataset/activity_labels.txt", header = FALSE)
names(activities) <- c("activityCode","activityName") # rename cols

# Test Data ====

#  import test data & apply descriptive names to the column headers
testData <- read.table(file = "./UCI_HAR_Dataset/test/X_test.txt", header = FALSE)
colnames(testData) <- features # assign descriptive names to testData columns

# import corresponding activities data; and tidy
testActivities <- read.table(file = "./UCI_HAR_Dataset/test/y_test.txt", header = FALSE)
names(testActivities) <-"activityCode" # usefully rename column

# use plyr package to merge get a column with descriptions associated with activities codes i.e. 1=WALKING, 5=STANDING etc
# this fulfils Course Project requirement 4
library(plyr)
testActivities <- join(testActivities,activities,by="activityCode")

# append the column of descriptive names for the activities to the testData
testData <- cbind(testActivities$activityName, testData)
names(testData)[1] <- "Activity" # give col a more descriptive name

# import the test subjects
testSubjects <- read.table(file = "./UCI_HAR_Dataset/test/subject_test.txt", header = FALSE)

# append the testSubjects data to the testData
testData <- cbind(testSubjects, testData)
names(testData)[1] <- "Subject" # give col a more descriptive name

# this finishes the tidying of the Test Dataset

# Training Data =====

# proceed similarly as for the test data

#  import train data
trainData <- read.table(file = "./UCI_HAR_Dataset/train/X_train.txt", header = FALSE)
colnames(trainData) <- features # assign descriptive names to trainData columns

# import corresponding activities data; and tidy
trainActivities <- read.table(file = "./UCI_HAR_Dataset/train/y_train.txt", header = FALSE)
names(trainActivities) <-"activityCode" # usefully rename column

# use plyr package to merge get a column with descriptions associated with activities codes i.e. 1=WALKING, 5=STANDING etc
# this fulfils Course Project requirement 4
library(plyr)
trainActivities <- join(trainActivities,activities,by="activityCode")

# append the column of descriptive names for the activities to the trainData
trainData <- cbind(trainActivities$activityName, trainData)
names(trainData)[1] <- "Activity" # give col a more descriptive name

# import the training subjects
trainSubjects <- read.table(file = "./UCI_HAR_Dataset/train/subject_train.txt", header = FALSE)

# append the trainSubjects data to the trainData
trainData <- cbind(trainSubjects, trainData)
names(trainData)[1] <- "Subject" # give col a more descriptive name

# this finishes the tidying of the training data

# Combine ====
# now combine testData and trainData into a single dataset
masterData <- data.frame() # initialise a dataframe that'll hold all data
masterData <- rbind(testData, trainData)

# sort by subject, then by activity
masterData <- arrange(masterData, Subject, Activity)

# this finishes Course Requirement 1

# 2. Extract Required Cols ====

# get the indices of the required cols: mean() and std()
meanCols <- grep("mean()", colnames(masterData)) # gets indices
stdCols <- grep("std()", colnames(masterData)) # gets indices

# subset the Master dataset by the required cols (incl. Subjects and Activities)
masterData2 <- masterData[, c(1,2,sort(c(meanCols, stdCols)))]

# this completes Course Requirement 2

# 3. Descriptive Activity Names ====
# please see above

# 4. Descriptive Variable Names ====
# please see above

# 5. Second Independent Data Set ====

library(dplyr)
?group_by
masterData3 <- tbl_df(masterData2)
by_subject <- group_by(masterData3, Subject)
summarize(by_subject, mean(colnames(by_subject)[3]))
summarize(by_subject, mean(Subject))

summarize(by_subject, means=mean(tBodyAcc-mean()-X))


tapply(masterData2[, 3], mean)
tapply(by_subject[3], mean)



