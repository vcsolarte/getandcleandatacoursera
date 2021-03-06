# The following code produces tidy2.txt into the current working directory 

## set working directory

setwd("/Users/..")

##  1 - read all the data

test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

# put it together
data <- rbind(cbind(test.subjects, test.labels, test.data), cbind(train.subjects, train.labels, train.data))

## 2 - read the features

features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# extract only means and standard deviations from data

data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

## 3 - read the descriptive activity names 

labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]

## 4 - first make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# then use the list as column names for data
colnames(data.mean.std) <- good.colnames

## 5 - find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],by=list(subject = data.mean.std$subject, label = data.mean.std$label),mean)

# write the data to a txt for course upload
write.table(format(aggr.data, scientific=T), "tidy2.txt", row.names=F, col.names=F, quote=2)
