#####
The run_analysis.R script downloads the training and testing data, processes and cleans
the data, and then creates a tidy summarized dataset.

As a first step, it downloads the data, unzips them, and loads the activity_levels.txt 
file and the features.txt file into the workspace.  The activity levels will be used to
provide a text field for the types of activity in our tidy dataset and the features file
will be used to create the variable names.

Next, the script loads in the training data files subject_train,txt, X_train.txt, and 
y_train.txt.  It then uses the features file to provide names to the measurement data.
Then the files are column bound together to index the measurements to subjects and
activities.

Next, the script loads in the testing data files subject_test,txt, X_test.txt, and 
y_test.txt.  It then uses the features file to provide names to the measurement data.
Then the files are column bound together to index the measurements to subjects and
activities.

The script then row binds these two datasets together.

Then via use of the dplyr and magrittr the measurement data is summarized to its average
values per subject-activity combination.  These average data are then written out as
datasummarized.txt