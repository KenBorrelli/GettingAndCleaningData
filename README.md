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