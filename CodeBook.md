Run run_analysis.R to perform the following actions/transformations:
- Download data file
- Unzip data file
- Flatten directory structure
- Read activity names into a data frame
- for every measurement file
 - read file
 - caluclate the mean and sd for every row
 - bind the mean and sd as new column to our data frame
- merge the measurements and activity labels
- for every subject and activity type calculate the mean of every measurement

Data format of the tidy dataset:
- subject: the id of the subject (1-30)
- activity: name of the activity measured
- X: X measurements
- body_acc_...: The average of the body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- body_gyro_...: The average of the angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.
- total_acc_...: The average of the acceleration signal from the smartphone accelerometer in standard gravity units 'g'.

