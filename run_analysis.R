# Reads in the UCI HAR Dataset (in a subdirectory of the working diectory) and
# Creates a tidy data set containing the mean and std of all featues that include
# the word mean or std (this corresponds to features which are the mean or standard 
# deviation of sensor readings) and aggregates them into groups by the subject ID (an integer)
# and the activity being performed (Sitting, Walking, etc).  There is one group fo each
# unique combination of subject and activity.
# Features are 
#     Subject.Activity: The subject ID and acitivty seperated by a |, ie "3 | Walking"
#     MEAN.<FEATURE> : The mean of featue <FEATURE> over all recoding for a given
#                       Subject.Activity combination.  Features are descibed in 
#                       the original data set in a features.info file
#     STD.<FEATURE> : The standard deviation of feature <FEATURE> over all recoding for a given
#                       Subject.Activity combination.  Features are descibed in 
#                       the original data set in a features.info file
#    
run_analysis = function(){
    dir = "UCI HAR Dataset";
    # Read in the feature names
    path_features = paste(dir, "features.txt", sep="/")
    features = as.vector(read.table(path_features)$V2)
    # Read in the training Data
    path_train_x = paste(dir, "train", "X_train.txt", sep="/")
    path_train_Y = paste(dir, "train", "Y_train.txt", sep="/")
    path_train_s = paste(dir, "train", "subject_train.txt", sep="/")
    x_train = read.table(path_train_x)
    colnames(x_train) = features
    Y_train = read.table(path_train_Y)
    colnames(Y_train) = c("Activity")
    subject_train = read.table(path_train_s)
    colnames(subject_train) = c("Subject")
    #train = cbind(Y_train, subject_train, x_train)
    # Read in the test data
    path_test_x = paste(dir, "test", "X_test.txt", sep="/")
    path_test_Y = paste(dir, "test", "Y_test.txt", sep="/")
    path_test_s = paste(dir, "test", "subject_test.txt", sep="/")
    x_test = read.table(path_test_x)
    colnames(x_test) = features
    Y_test = read.table(path_test_Y)
    colnames(Y_test) = c("Activity")
    subject_test = read.table(path_test_s)
    colnames(subject_test) = c("Subject")
    #test = cbind(Y_test, subject_test, x_test)
    # Merge the two datasets
    full_x = rbind(x_train, x_test)
    full_Y = rbind(Y_train, Y_test)
    full_subject = rbind(subject_train, subject_test)
    # data = rbind(train, test)
    # Set up activities
    act_titles = as.vector(read.table(paste(dir, "activity_labels.txt", sep="/"))$V2)
    act = c()
    for ( i in 1:nrow(full_Y)){
        act = c(act, act_titles[full_Y$Activity[i]])
    }
    full_Y$Activity = act
    #Keep only mean and std featues
    f_to_keep = c()
    for (f in features){
        if(regexpr("mean", f)!=-1 || regexpr("std", f)!=-1){
            f_to_keep = c(f_to_keep, f)
        }
    }
    full_ms = full_x[f_to_keep]
    # Create a tidy dataset
    agg_value = c()
    for (i in 1:nrow(full_Y)){
        agg_value = c(agg_value, paste(full_subject$Subject[i], full_Y$Activity[i], sep=" | "))
    }
    agg_mean = aggregate(full_ms, by=list(agg_value ), FUN=mean)
    agg_std = aggregate(full_ms, by=list(agg_value ), FUN=sd)
    
    colnames(agg_mean)[1] ="Subject.Activity"
    colnames(agg_std)[1] ="Subject.Activity"
    for (i in 2:ncol(agg_mean)){
        colnames(agg_mean)[i] = paste("MEAN", colnames(agg_mean)[i], sep=" ")
        colnames(agg_std)[i] = paste("STD", colnames(agg_std)[i], sep=" ")
    }
    tidy_data = data.frame(agg_mean, agg_std[2:ncol(agg_std)])
    write.table(tidy_data, file="tidy_data.txt", row.name=F)
    return(tidy_data)
    
    
    
}

