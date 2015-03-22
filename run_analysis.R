
## Following function download and unzips the dataset
download.data <- function() {

	sourceurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	destfilename <- "uci_har_dataset.zip"
	cat("Downloading dataset...\n")
	download.file(sourceurl, destfile=destfilename, method="curl")
	unzip(destfilename)
	cat("Dataset has been downloaded. Please invoke 'run.analysis()' to load and process the dataset.\n")
}

## Following function loads specified dataset from file. It also creates
## subset of loaded dataset based on given features and assign given 
## names to variables.
load.dataset <- function(type, selected.features, activity.labels){
	path <- paste0(type, "/")
	feature.vectors.file <- paste0(path, 'X_', type, '.txt')
	activity.labels.file <- paste0(path, 'y_', type, '.txt')
	subject.ids.file <- paste0(path, 'subject_', type, '.txt')

	# Load data files
	feature.vectors.data <- read.table(feature.vectors.file)[,selected.features$id]
	activity.labels.data <- read.table(activity.labels.file)[,1]
	subject.ids.data <- read.table(subject.ids.file)[,1]

	# Name variables
	names(feature.vectors.data) <- selected.features$label
	feature.vectors.data$label <- factor(activity.labels.data, levels=activity.labels$id, labels=activity.labels$label)
	feature.vectors.data$subject <- factor(subject.ids.data)

	# Return processed dataset
	feature.vectors.data
}

## Following function loads training and test dataset (using load.dataset function) 
## from respective files. It merges those dataset. From this dataset then it creates 
## a second, independent tidy dataset with the average of each variable for each 
## activity and each subject.
run.analysis <- function() {
	setwd("UCI HAR Dataset/")

	# Load id->feature label data
	feature.vector.labels.data <- read.table("features.txt", col.names = c("id","label"))
	
	# Select only the measurements on the mean and standard deviation for each measurement.
	# Using grepl we can return logical vector of matching rows.
	# Features we want to select have -mean() or -std() as a part of the name.
	selected.features <- subset(feature.vector.labels.data, grepl("-(mean|std)\\(", feature.vector.labels.data$label))
	
	# Load id->activity label data
	activity.labels <- read.table("activity_labels.txt", col.names = c("id", "label"))
	
	# Read train and test data sets
	cat("reading training dataset...\n")
	train.df <- load.dataset("train", selected.features, activity.labels)
	cat("reading test dataset...\n")
	test.df <- load.dataset("test", selected.features, activity.labels)

	# Merge train and test sets
	cat("merging training and test datasets...\n")
	merged.df <- rbind(train.df, test.df)
	cat("Finished dataset loading and merging.\n")
	
	# Convert to data.table for making it easier and faster
	# to calculate mean for activity and subject groups.
	merged.dt <- data.table(merged.df)
	
	# Calculate the average of each variable for each activity and each subject.
	tidy.dt <- merged.dt[, lapply(.SD, mean), by=list(label,subject)]
	
	# Tidy variable names
	tidy.dt.names <- names(tidy.dt)
	tidy.dt.names <- gsub("-mean", 'Mean', tidy.dt.names)
	tidy.dt.names <- gsub("-std", "Std", tidy.dt.names)
	tidy.dt.names <- gsub("[()-]", "", tidy.dt.names)
	tidy.dt.names <- gsub("BodyBody", "Body", tidy.dt.names)
	setnames(tidy.dt, tidy.dt.names)
	
	# Save dataset
	setwd('..')
	write.table(merged.dt, file = "raw-dataset.txt", row.names = FALSE)
	write.table(tidy.dt, file = "tidy-dataset.txt", row.names = FALSE, quote = FALSE)
	cat("Finished processing. Raw and tidy dataset are written to raw-dataset.txt and tidy-dataset.txt respectively.\n")

	# Return the tidy data set
	return(tidy.dt)
}

if (!require("downloader", quietly = TRUE)) {
	cat("Trying to install required package - 'downloader'...\n")
	install.packages("downloader", quiet = TRUE)
	if (!require("downloader", quietly = TRUE)) {
		cat("Package 'downloader' installed and loaded.\n")
	} else {
		stop("Could not install package 'downloader'!\n")
	}
}

if (!require("data.table", quietly = TRUE)) {
	cat("Trying to install required package - 'downloader'...\n")
	install.packages("data.table", quiet = TRUE)
	if (!require("data.table", quietly = TRUE)) {
		cat("Package 'data.table' installed and loaded.\n")
	} else {
		stop("Could not install package 'data.table'!\n")
	}
}

cat("To download data, call 'download.data()' and then to process and get the tidy data set, call 'run.analysis()'. If data is already downloaded and unarchived and 'UCI HAR Dataset' sub-directory is already present under the current directory, then you can call 'run.analysis()' straight away.\n")