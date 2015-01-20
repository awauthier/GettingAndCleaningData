# 1. Merge the training and the test sets to create one data set.
# Reading the files
xTests <- read.table("test/X_test.txt")
yTests <- read.table("test/y_test.txt")
sTests <- read.table("test/subject_test.txt")
xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
sTrain <- read.table("train/subject_train.txt")
actlbl <- read.table("activity_labels.txt")
features <- read.table("features.txt")

x <- rbind(xTrain, xTests)
y <- rbind(yTrain, yTests)
s <- rbind(sTrain, sTests)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
measurementMeans <- colMeans(x)
measurementStandardDeviation <- apply(x,2,sd)

# 3. Use descriptive activity names to name the activities in the data set
y$name <- actlbl[y[,1],2]
basedata <- cbind(x,y$name)

# 4. Appropriately label the data set with descriptive variable names. 
# Remark that we have one more column than the original set with the activities names
names(basedata) <- c(as.character(features[,2]), "activityName")

# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
# Add subjects to the data set
data <- cbind(basedata, s)
names(data)[563] <- "subject"

# Get the result
result <- aggregate(data, by=list(data$activityName, data$subject), mean)

# Set correct names for the 2 aggregated columns
n <- names(result)
n[1] <- "activityName"
n[2] <- "subject"
names(result) <- n

# Store the result
write.table(result, file="tidyDataSet.txt", row.name=FALSE)
