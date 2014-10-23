---
title: "Peer Evaluation Project-getdata-008"
author: "Erik Rodriguez Pacheco"
date: "Wednesday, October 22, 2014"
output: html_document
---

## Initial preparation


Load the packages and set working directory


```r
library(data.table)
library(reshape2)
library(knitr)
library(markdown)
Dir <- getwd()
Dir
```

```
## [1] "c:/Users/Eropa1981/Dropbox/didacticos/Estudio/Johns Hopkins University/03-Getting and Cleaning Data/Assingment"
```

## Obtaining the data
  
Download data in Assingment folder


```r
link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
x <- "Data.zip"
if (!file.exists(Dir)) {dir.create(Dir)}
download.file(link, file.path(Dir, x))
```

## Extract Data for working

Running external program 7zip to extract data from zip dowloaded


```r
zip <- file.path("C:", "Program Files", "7-Zip", "7z.exe")
set<-"x"
extract <- paste(paste0("\"", zip, "\""), set, paste0("\"", file.path(Dir, x), "\""))
suppressMessages(suppressWarnings(system(extract)))
```

```
## Error: character string expected as first argument
```

The file contains the directory UCI HAR Dataset will be the new directory
This is a list of the files inside that directory


```r
Dirdata <- file.path(Dir, "UCI HAR Dataset")
list.files(Dirdata, recursive=TRUE)
```

```
##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"
```

## Read Information with data.table and read table


Is necesary read data from Subject Files and the activity train

```r
SubjTrain <- fread(file.path(Dirdata, "train", "subject_train.txt"))
SubjTest  <- fread(file.path(Dirdata, "test" , "subject_test.txt" ))
```


```r
ActTrain <- fread(file.path(Dirdata, "train", "Y_train.txt"))
ActTest  <- fread(file.path(Dirdata, "test" , "Y_test.txt" ))
```



Now is necesary read the data 

fread function is not working very well for import data from X_train,txt and X.test.txt.
alternative solution is use read table, create data frame and finally transform this data frame 
in data.table objects


```r
#Train <- fread(file.path(Dirdata, "train", "X_train.txt"))
#Test  <- fread(file.path(Dirdata, "test" , "X_test.txt" ))
Train<-read.table(file.path(Dirdata, "train", "X_train.txt"))
Test<-read.table(file.path(Dirdata, "test", "X_test.txt"))
Train<-data.table(Train)
class(Train)
```

```
## [1] "data.table" "data.frame"
```

```r
Test<-data.table(Test)
class(Test)
```

```
## [1] "data.table" "data.frame"
```


## 1-Merges the training and the test sets to create one data set
  

```r
Subject <- rbind(SubjTrain, SubjTest)
setnames(Subject, "V1", "subject")
Activity <- rbind(ActTrain, ActTest)
setnames(Activity, "V1", "activityNum")
data <- rbind(Train, Test)

Subject <- cbind(Subject, Activity)
data <- cbind(Subject, data)

setkey(data, subject, activityNum)
```

## 2-Extracts only the measurements on the mean and standard deviation for each measurement


```r
Feat <- fread(file.path(Dirdata, "features.txt"))
setnames(Feat, names(Feat), c("featureNum", "featureName"))
Feat <- Feat[grepl("mean\\(\\)|std\\(\\)", featureName)]
Feat$featureCode <- Feat[, paste0("V", featureNum)]
head(Feat)
```

```
##    featureNum       featureName featureCode
## 1:          1 tBodyAcc-mean()-X          V1
## 2:          2 tBodyAcc-mean()-Y          V2
## 3:          3 tBodyAcc-mean()-Z          V3
## 4:          4  tBodyAcc-std()-X          V4
## 5:          5  tBodyAcc-std()-Y          V5
## 6:          6  tBodyAcc-std()-Z          V6
```

```r
Feat$featureCode
```

```
##  [1] "V1"   "V2"   "V3"   "V4"   "V5"   "V6"   "V41"  "V42"  "V43"  "V44" 
## [11] "V45"  "V46"  "V81"  "V82"  "V83"  "V84"  "V85"  "V86"  "V121" "V122"
## [21] "V123" "V124" "V125" "V126" "V161" "V162" "V163" "V164" "V165" "V166"
## [31] "V201" "V202" "V214" "V215" "V227" "V228" "V240" "V241" "V253" "V254"
## [41] "V266" "V267" "V268" "V269" "V270" "V271" "V345" "V346" "V347" "V348"
## [51] "V349" "V350" "V424" "V425" "V426" "V427" "V428" "V429" "V503" "V504"
## [61] "V516" "V517" "V529" "V530" "V542" "V543"
```

```r
subset <- c(key(data), Feat$featureCode)
data <- data[, subset, with=FALSE]
head(data)
```

```
##    subject activityNum     V1        V2       V3      V4       V5      V6
## 1:       1           1 0.2820 -0.037696 -0.13490 -0.3283 -0.13715 -0.1891
## 2:       1           1 0.2558 -0.064550 -0.09519 -0.2292  0.01651 -0.2603
## 3:       1           1 0.2549  0.003815 -0.12366 -0.2752  0.01308 -0.2844
## 4:       1           1 0.3434 -0.014446 -0.16738 -0.2299  0.17391 -0.2134
## 5:       1           1 0.2762 -0.029638 -0.14262 -0.2266  0.16429 -0.1225
## 6:       1           1 0.2555  0.021219 -0.04895 -0.2245  0.02231 -0.1132
##       V41     V42      V43     V44     V45     V46     V81     V82
## 1: 0.9453 -0.2459 -0.03216 -0.9840 -0.9289 -0.9326 -0.1565 -0.1429
## 2: 0.9411 -0.2520 -0.03288 -0.9840 -0.9175 -0.9491 -0.2076  0.3578
## 3: 0.9464 -0.2643 -0.02558 -0.9628 -0.9561 -0.9719  0.2016  0.4171
## 4: 0.9524 -0.2598 -0.02613 -0.9811 -0.9644 -0.9643  0.3361 -0.4641
## 5: 0.9471 -0.2571 -0.02842 -0.9769 -0.9886 -0.9604 -0.2356 -0.1118
## 6: 0.9457 -0.2548 -0.02652 -0.9853 -0.9802 -0.9663  0.1159  0.2347
##          V83     V84      V85     V86      V121     V122     V123    V124
## 1: -0.113079 -0.1838 -0.17046 -0.6138 -0.479730  0.08203 0.256443 -0.3235
## 2: -0.452401 -0.1084 -0.01869 -0.5476  0.094091 -0.30915 0.086441 -0.3993
## 3:  0.139078 -0.1777 -0.02960 -0.5795  0.211201 -0.27291 0.101986 -0.4454
## 4: -0.005026 -0.1205  0.02866 -0.5215  0.096082 -0.16339 0.025859 -0.3604
## 5:  0.172655 -0.1924  0.05398 -0.4693  0.008742  0.01166 0.004175 -0.3776
## 6:  0.361505 -0.2458 -0.02057 -0.4659 -0.042557  0.09762 0.084655 -0.5109
##        V125    V126     V161     V162     V163    V164    V165    V166
## 1: -0.14194 -0.4566  0.09425 -0.47621 -0.14213 -0.3457 -0.4867 -0.4215
## 2: -0.08842 -0.4022  0.16674 -0.03380 -0.08926 -0.2499 -0.4537 -0.3698
## 3: -0.06308 -0.3471 -0.16323 -0.00556 -0.23155 -0.2642 -0.4247 -0.3425
## 4:  0.04233 -0.2761 -0.05463  0.34029 -0.26967 -0.1021 -0.2434 -0.3116
## 5:  0.13372 -0.3081 -0.07567  0.17147  0.13645 -0.1291 -0.1901 -0.4183
## 6:  0.02642 -0.3724 -0.33244 -0.40625  0.23877 -0.2875 -0.2924 -0.4826
##        V201    V202     V214    V215    V227    V228     V240     V241
## 1: -0.22456 -0.2380 -0.22456 -0.2380 -0.2894 -0.1650 -0.03440 -0.16819
## 2: -0.12650 -0.2134 -0.12650 -0.2134 -0.1385 -0.1986 -0.14094 -0.21606
## 3: -0.16010 -0.2576 -0.16010 -0.2576 -0.1944 -0.2199 -0.09459 -0.29085
## 4: -0.07351 -0.1951 -0.07351 -0.1951 -0.1295 -0.1739 -0.04934 -0.09012
## 5: -0.04949 -0.2110 -0.04949 -0.2110 -0.1599 -0.1499 -0.02141 -0.04464
## 6: -0.07739 -0.2378 -0.07739 -0.2378 -0.2060 -0.1993 -0.13888 -0.16731
##       V253    V254    V266     V267    V268    V269     V270    V271
## 1: -0.4661 -0.4337 -0.2609 -0.12257 -0.3312 -0.3567 -0.19957 -0.1778
## 2: -0.3899 -0.4390 -0.1511 -0.02905 -0.2573 -0.2622 -0.02386 -0.3222
## 3: -0.3742 -0.4180 -0.2304  0.02543 -0.3773 -0.2935 -0.05769 -0.2901
## 4: -0.2365 -0.2294 -0.1513  0.19527 -0.3212 -0.2631  0.08786 -0.2170
## 5: -0.2201 -0.2128 -0.2258  0.11029 -0.2049 -0.2268  0.11880 -0.1464
## 6: -0.3038 -0.3744 -0.2904  0.05782 -0.2484 -0.2000 -0.06210 -0.1107
##       V345     V346    V347    V348      V349    V350    V424     V425
## 1: -0.2105 -0.26353 -0.5357 -0.2283 -0.124274 -0.6984 -0.1848 -0.19802
## 2: -0.1783 -0.12084 -0.4989 -0.1140  0.027848 -0.5946 -0.2045 -0.24583
## 3: -0.1927 -0.10961 -0.5256 -0.2359 -0.005816 -0.6329 -0.3171 -0.20816
## 4: -0.1834 -0.02597 -0.4874 -0.1323  0.020367 -0.5528 -0.1622  0.02655
## 5: -0.2852 -0.01110 -0.4259 -0.1692  0.055777 -0.5102 -0.2371  0.04721
## 6: -0.2980 -0.05173 -0.4335 -0.2575 -0.052800 -0.4955 -0.3475 -0.03516
##       V426    V427      V428    V429     V503    V504    V516    V517
## 1: -0.3076 -0.3681 -0.115047 -0.5653 -0.16681 -0.3996 -0.1540 -0.1847
## 2: -0.3112 -0.4613 -0.009838 -0.4899 -0.07928 -0.4230 -0.1784 -0.2307
## 3: -0.1858 -0.4863  0.009727 -0.4694 -0.15631 -0.4369 -0.1494 -0.3213
## 4: -0.1805 -0.4235  0.044652 -0.3766 -0.10438 -0.3762 -0.1322 -0.2326
## 5: -0.2580 -0.4223  0.176016 -0.3886 -0.12320 -0.3879 -0.1161 -0.2010
## 6: -0.3338 -0.5630  0.055512 -0.4429 -0.20003 -0.3782 -0.1590 -0.2578
##         V529    V530    V542    V543
## 1: -0.222176 -0.2736 -0.4318 -0.4764
## 2: -0.268280 -0.3146 -0.4282 -0.4929
## 3: -0.308671 -0.4014 -0.4010 -0.4819
## 4: -0.060131 -0.2746 -0.2177 -0.2992
## 5: -0.003821 -0.2462 -0.1876 -0.3003
## 6: -0.174531 -0.3074 -0.3384 -0.4650
```

## 3-Uses descriptive activity names to name the activities in the data set


```r
ActNames <- fread(file.path(Dirdata, "activity_labels.txt"))
setnames(ActNames, names(ActNames), c("activityNum", "activityName"))
```

## 4-Appropriately labels the data set with descriptive activity names.


```r
data <- merge(data, ActNames, by="activityNum", all.x=TRUE)
setkey(data, subject, activityNum, activityName)

data <- data.table(melt(data, key(data), variable.name="featureCode"))
data <- merge(data, Feat[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)
data$activity <- factor(data$activityName)
data$feature <- factor(data$featureName)
```

Seperate features from FeatureName


```r
SepFeatures <- function (regex) {
  grepl(regex, data$feature)
}

n <- 2
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(SepFeatures("^t"), SepFeatures("^f")), ncol=nrow(y))
data$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))
x <- matrix(c(SepFeatures("Acc"), SepFeatures("Gyro")), ncol=nrow(y))
data$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
x <- matrix(c(SepFeatures("BodyAcc"), SepFeatures("GravityAcc")), ncol=nrow(y))
data$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
x <- matrix(c(SepFeatures("mean()"), SepFeatures("std()")), ncol=nrow(y))
data$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))
data$featJerk <- factor(SepFeatures("Jerk"), labels=c(NA, "Jerk"))
data$featMagnitude <- factor(SepFeatures("Mag"), labels=c(NA, "Magnitude"))

n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(SepFeatures("-X"), SepFeatures("-Y"), SepFeatures("-Z")), ncol=nrow(y))
data$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))
```


```r
x1 <- nrow(data[, .N, by=c("feature")])
x2 <- nrow(data[, .N, by=c("featDomain", "featAcceleration", "featInstrument", "featJerk", "featMagnitude", "featVariable", "featAxis")])
identical(x1,x2)
```

```
## [1] TRUE
```


## 5-Creates a second, independent tidy data set with the average of each variable for 
## each activity and each subject.



```r
setkey(data, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
dataTidy <- data[, list(count = .N, average = mean(value)), by=key(data)]
dataTidy
```

```
##        subject         activity featDomain featAcceleration featInstrument
##     1:       1           LAYING       Time               NA      Gyroscope
##     2:       1           LAYING       Time               NA      Gyroscope
##     3:       1           LAYING       Time               NA      Gyroscope
##     4:       1           LAYING       Time               NA      Gyroscope
##     5:       1           LAYING       Time               NA      Gyroscope
##    ---                                                                    
## 11876:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11877:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11878:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11879:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11880:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
##        featJerk featMagnitude featVariable featAxis count  average
##     1:       NA            NA         Mean        X    50 -0.01655
##     2:       NA            NA         Mean        Y    50 -0.06449
##     3:       NA            NA         Mean        Z    50  0.14869
##     4:       NA            NA           SD        X    50 -0.87354
##     5:       NA            NA           SD        Y    50 -0.95109
##    ---                                                            
## 11876:     Jerk            NA           SD        X    65 -0.56157
## 11877:     Jerk            NA           SD        Y    65 -0.61083
## 11878:     Jerk            NA           SD        Z    65 -0.78475
## 11879:     Jerk     Magnitude         Mean       NA    65 -0.54978
## 11880:     Jerk     Magnitude           SD       NA    65 -0.58088
```

## Codebook


```r
knit("makeCodebook.Rmd", output="Codebook.md", encoding="ISO8859-1")
```

```
## Warning: cannot open file 'makeCodebook.Rmd': No such file or directory
```

```
## Error: cannot open the connection
```

```r
markdownToHTML("Codebook.md", "Codebook.html")
```

```
## Warning: cannot open file 'Codebook.md': No such file or directory
```

```
## Error: cannot open the connection
```
