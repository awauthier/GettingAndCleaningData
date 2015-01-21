---
title: "Code book"
author: "Alain Wauthier"
date: "Tuesday, January 20, 2015"
output: html_document
---

### 1. Merge the training and the test sets to create one data set.

The first step loads all the data from the text files


```r
xTest <- read.table("test/X_test.txt")  
yTest <- read.table("test/y_test.txt")  
sTest <- read.table("test/subject_test.txt")  
xTrain <- read.table("train/X_train.txt")  
yTrain <- read.table("train/y_train.txt")  
sTrain <- read.table("train/subject_train.txt")  
actlbl <- read.table("activity_labels.txt")  
features <- read.table("features.txt")  
```
Next, we merge the Train set with the Test set

```r
x <- rbind(xTrain, xTest)  
y <- rbind(yTrain, yTest)  
s <- rbind(sTrain, sTest)
```
The resulting x data set contains all the measures from the both sources Train and Test.

### 2. Extract only the measurements on the mean and standard deviation for each measurement.
We can here use the colMeans function in order to extract the mean of each measurement.  
To calculate the standard deviation, we have to use the apply function on each column of the data set.

```r
measurementsMean <- colMeans(x)
measurementsSD <- apply(x,2,sd)
```
Here is an extract of the means of the measurements

```r
measurementsMean[1:12]
```

```
##          V1          V2          V3          V4          V5          V6 
##  0.27434726 -0.01774349 -0.10892503 -0.60778382 -0.51019138 -0.61306430 
##          V7          V8          V9         V10         V11         V12 
## -0.63359261 -0.52569654 -0.61498891 -0.46673237 -0.30518046 -0.56222962
```
Here is an extract of the standard deviation of the measurements

```r
measurementsSD[1:12]
```

```
##         V1         V2         V3         V4         V5         V6 
## 0.06762780 0.03712817 0.05303309 0.43869383 0.50023977 0.40365658 
##         V7         V8         V9        V10        V11        V12 
## 0.41333302 0.48420065 0.39903406 0.53870679 0.27992028 0.28299053
```

### 3. Use descriptive activity names to name the activities in the data set
We first add in the y dataset the names coming from the actlbl dataset (activity labels).  
Then we can add the activity labels list to the x dataset

```r
y$name <- actlbl[y[,1],2]  
x <- cbind(x,y$name)
```
Here is an extract of the resulting dataset:

```r
head(x[,558:562])
```

```
##          V558       V559      V560        V561   y$name
## 1 -0.01844588 -0.8412468 0.1799406 -0.05862692 STANDING
## 2  0.70351059 -0.8447876 0.1802889 -0.05431672 STANDING
## 3  0.80852908 -0.8489335 0.1806373 -0.04911782 STANDING
## 4 -0.48536645 -0.8486494 0.1819348 -0.04766318 STANDING
## 5 -0.61597061 -0.8478653 0.1851512 -0.04389225 STANDING
## 6 -0.36822404 -0.8496316 0.1848225 -0.04212638 STANDING
```

### 4. Appropriately label the data set with descriptive variable names. 
Remark that we have one more column than the original set with the activities names, so we need to name this extra column also.

```r
names(x) <- c(as.character(features[,2]), "activityName")
```
Here is an extract of the resulting dataset:

```r
head(x[,558:562])
```

```
##   angle(tBodyGyroJerkMean,gravityMean) angle(X,gravityMean)
## 1                          -0.01844588           -0.8412468
## 2                           0.70351059           -0.8447876
## 3                           0.80852908           -0.8489335
## 4                          -0.48536645           -0.8486494
## 5                          -0.61597061           -0.8478653
## 6                          -0.36822404           -0.8496316
##   angle(Y,gravityMean) angle(Z,gravityMean) activityName
## 1            0.1799406          -0.05862692     STANDING
## 2            0.1802889          -0.05431672     STANDING
## 3            0.1806373          -0.04911782     STANDING
## 4            0.1819348          -0.04766318     STANDING
## 5            0.1851512          -0.04389225     STANDING
## 6            0.1848225          -0.04212638     STANDING
```

### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
Add first the subjects to the data set (with the correct column title):

```r
data <- cbind(x, s)  
names(data)[563] <- "subject"
```
Aggregate the data:

```r
result <- aggregate(data, by=list(data$activityName, data$subject), mean)
```
Set correct names for the 2 aggregated columns

```r
n <- names(result)  
n[1] <- "activityName"  
n[2] <- "subject"  
names(result) <- n
```
Here is an extract of the resulting dataset:

```r
head(x[,1:8])
```

```
##   tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X
## 1         0.2885845       -0.02029417        -0.1329051       -0.9952786
## 2         0.2784188       -0.01641057        -0.1235202       -0.9982453
## 3         0.2796531       -0.01946716        -0.1134617       -0.9953796
## 4         0.2791739       -0.02620065        -0.1232826       -0.9960915
## 5         0.2766288       -0.01656965        -0.1153619       -0.9981386
## 6         0.2771988       -0.01009785        -0.1051373       -0.9973350
##   tBodyAcc-std()-Y tBodyAcc-std()-Z tBodyAcc-mad()-X tBodyAcc-mad()-Y
## 1       -0.9831106       -0.9135264       -0.9951121       -0.9831846
## 2       -0.9753002       -0.9603220       -0.9988072       -0.9749144
## 3       -0.9671870       -0.9789440       -0.9965199       -0.9636684
## 4       -0.9834027       -0.9906751       -0.9970995       -0.9827498
## 5       -0.9808173       -0.9904816       -0.9983211       -0.9796719
## 6       -0.9904868       -0.9954200       -0.9976274       -0.9902177
```
Store the result in a file:

```r
write.table(result, file="tidyDataSet.txt", row.name=FALSE)
```
