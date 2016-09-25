# getting-and-cleaning-data
Course project for Coursera's Getting and Cleaning Data


Readme

The script included is run_analysis.R. It creates two datasets from the files contained in UCI HAR Dataset. When running this file, please set the directory to 'UCI HAR Dataset' to ensure the paths to the files can be accessed. The first dataset ('original.txt') concatenates and puts together all the files obtained in the UCI HAR Dataset to produce a file that has the subject and activity corresponding to the variables produced by the accelerometer and gyroscope. The second dataset ('averages.txt') cleans it up and only produces the average of the variables related to the mean and standard deviation for each subject and activity each subject performs.


