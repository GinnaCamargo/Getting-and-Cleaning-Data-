if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

## 1. Merges the training and the test sets to create one data set.

activity_labels<-read.table("activity_labels.txt")[,2]

features<-read.table("features.txt")[,2]


#Load: test folders files.
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# Load and process X_train & y_train data.
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

X_test<-setNames(X_test,features)
X_train<-setNames(X_train,features)

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test<-X_test[,grepl("mean|std", features)]
X_train<-X_train[,grepl("mean|std", features)]

#Load activity labels
y_test[,2]=activity_labels[y_test[,1]]
y_test<-setNames(y_test ,c("Activity ID","Activity Label"))
subject_test<-setNames(subject_test,"Subject")

y_train[,2]=activity_labels[y_train[,1]]
y_train<-setNames(y_train ,c("Activity ID","Activity Label"))
subject_train<-setNames(subject_train,"Subject")

# Bind data
test<-cbind(as.data.table(subject_test), y_test, X_test)
train <-cbind(subject_train, y_train, X_train)

#Merges the training and the test
data<-rbind(test,train)

data_labels<-setdiff(colnames(data),c("Subject", "Activity ID", "Activity Label"))
melt_data <- melt(data, id = c("Subject", "Activity ID", "Activity Label"), measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data<-dcast(melt_data, Subject+activity_labels ~ variable, mean)

# write the tidy data set to a file
write.table(tidy_data, file = "./tidy_data.txt")
