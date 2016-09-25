run_analysis <- function(){
  
  library(dplyr)
  library(reshape2)
  
  #Step 1: Merges the training and the test sets to create one data set.
  #        Will take the paths of each file and conduct the necessary steps
  #        to place the subject and activity on the left, and the raw data on
  #        the right. Will only define first two columns.
  
  
  subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
  subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
  y_train <- read.table('UCI HAR Dataset/train/y_train.txt')
  y_test <- read.table('UCI HAR Dataset/test/y_test.txt')
  activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')
  
  subjects_together <- rbind(subject_train, subject_test)
  activities_together <- rbind(y_train, y_test)
  
  #Add subject and activities together and name accordingly
  sub_acts_together <- cbind(subjects_together, activities_together)
  colnames(sub_acts_together) <- c('Subject', 'Activity')
  
  #Building X test and train data
  x_train <- read.table('UCI HAR Dataset/train/X_train.txt')
  x_test <- read.table('UCI HAR Dataset/test/X_test.txt')
  
  x_complete <- rbind(x_train, x_test)
  
  #Labeling x data
  features <- read.table('UCI HAR Dataset/features.txt')
  new_feat <- select(features, V2)
  t_new_feat <- t(new_feat)
  colnames(x_complete) <- t_new_feat
  
  #Adding our subjects/activities to x data
  
  x_complete <- cbind(sub_acts_together, x_complete)
  
  ##Step 2: Get measurements associated with mean and standard deviation...
  
  x_reduced <- x_complete[c(1,2,grep('.mean\\(', colnames(x_complete)), grep('.std()', colnames(x_complete)))]
  
  ##Step 3: Uses descriptive activity names to name the activities in the data set
          #Find a way to substitute the numbers in the column Activity with the activities associated in the activity labels file.
          #Maybe use merge-- do not sort
  
  step_3 <- merge(activity_labels, x_reduced, by.x = 'V1', by.y = 'Activity', sort= F)
  step_3 <- select(step_3,-V1) 
  step_3 <- arrange(step_3, Subject)
  
  
  #Step 4: Appropriately labels the data set with descriptive variable names.
  
  #Signals first- 't-'
  
  colnames(step_3) <- gsub('^t', 'Body', colnames(step_3))
  colnames(step_3) <- gsub('Acc', 'Accelerator', colnames(step_3))
  colnames(step_3) <- gsub('Jerk', ' Jerk ', colnames(step_3))
  colnames(step_3) <- gsub('Gyro', ' Gyro ', colnames(step_3))
  
  colnames(step_3) <- gsub('^f', 'FFT.', colnames(step_3))
  colnames(step_3) <- gsub('BodyBody', 'Body', colnames(step_3))
  colnames(step_3) <- gsub('.Mag.', 'Magnitude', colnames(step_3))
  
  #Making means look pretty
  colnames(step_3) <- gsub('.mean\\(\\)', ': Mean', colnames(step_3))
  colnames(step_3) <- gsub('std()', ': Standard Deviation', colnames(step_3))
  
  #Labeling subject
  colnames(step_3)[1] <- 'Activity'
  
  write.csv(step_3, 'original.txt', row.names = F)
  
  ##Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
  sub_factor <- as.factor(step_3$Subject)
  act_factor <- as.factor(step_3$Activity)
  
  tidy_data <-aggregate(. ~Subject + Activity, step_3, mean)
  
  write.csv(tidy_data, 'averages.txt', row.names = F)
  }