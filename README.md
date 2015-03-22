Coursera "Getting and Cleaning Data" - Course Project
===================================================

Course project deliverables for the Coursera course [Getting and Cleaning Data](https://www.coursera.org/course/getdata)

## Instructions

1. Source the script `run_analysis.R`.
2. When sourced, the script checks if the required R packages are available and proceeds to install them if they are not found
3. Calling `download.data()` downloads the zipped dataset and unarchives it.
4. Calling `run.analysis()` starts the actual data processing, which are as follows:
   1. Feature vector label data is loaded from `features.txt`
   2. Using regex with grepl, subset of label data for selecting desired data columns is created. 
   3. Activity labels are loaded from `features.txt`
   4. Activity labels (id->label) and selected features (id->label) are given as parameters to function which loads the training or test dataset, based on the type value given also as a parameter.
       1. Paths to data files are created based on type parameter
       2. Data files are loaded. Feature vector data is filtered using ids of the selected features.
       3. Activity and subject id data are loaded
       4. Feature vector data is renamed using the names of selected features
       5. Activies and subjects are given labels using factor levels of activity and subject id data.
       6. Finally, processed dataset is returned.
   5. The previous processing is repeated to both training and test datasets.
   6. Training and test datasets are merged using `rbind()` and converted to `data.table` to make it easier to do group-wise operations in the following step
   7. A new independent tidy dataset is created by calculating means for all variables for each activity and subject.
   8. Variable names are loaded to separate vector and modified to follow CamelCase convention. 
   9. New names are applied to tidy dataset.
   10. Both raw and tidy datasets are written to disk.
   11. Tidy datset is returned as output of the function.


In case the Samsung data is already unzipped and directory with the dataset is available as
 `UCI HAR Dataset` subdirectory of the current directory, the processing function `run.analysis()` can be 
 called straight away, no need to call `download.data()`.


## Cleaned dataset

At the end processing, both raw and tidy datasets are written to disk into raw-dataset.txt and tidy-dataset.txt respectively under the current working directory.
