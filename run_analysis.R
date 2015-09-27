library(reshape2)

#Read test Data
X_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt") #readings for each subject and activity for test group
y_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt") #activity for each test for the test group
subject_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt") #the subjects for each test for the test group (9 people: 2,4,9,10,12,13,18,20,24)

#Read train Data

X_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt") #readings for each subject and activity for test group
y_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt") #activity for each test for the train group (6 activities)
subject_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt") #the subjects for each test for the train group (21 people: 1,3,5-8,11,14-17,19,21-23,25-30)

#Read labels

features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt") #561 features measured
activity_labels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt") #6 Activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, AND LAYING


#Extract only the features that use "mean" or "std" in their names
extract_feat <- grepl("mean|std", as.character(features$V2))

X_test <- X_test[extract_feat]
X_train <- X_train[extract_feat]

#Create Activity Labels

train_act_labels <- activity_labels$V2[y_train$V1]
test_act_labels <- activity_labels$V2[y_test$V1]

#Bind data

train_data <- cbind(subject_train,train_act_labels,X_train)
test_data <- cbind(subject_test,test_act_labels,X_test)

#label columns
colnames(train_data) <- c("Subject","Activity",as.character(features$V2[extract_feat]))
colnames(test_data) <- c("Subject","Activity",as.character(features$V2[extract_feat]))

#Merge Data

mergedData<-rbind(train_data, test_data)

#Melt data to create unique variable, activity, and subject combinations

meltedData <- melt(mergedData, id= c("Subject","Activity"))

#cast the melted data to find the average for each variable

averageData <- dcast(meltedData,Subject+Activity~variable, mean)

#Write the final tidy data to a txt file

write.table(averageData, file = "./tidy_data.txt", row.name = FALSE)


