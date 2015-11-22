

# Johns Hopkins Data Science - Getting and Cleaning Data
# Delivered via Coursera

library(data.table)
library(dplyr)

train_x <- read.table("data/UCI HAR Dataset/train/X_train.txt",sep="",header = FALSE)
train_y <- read.table("data/UCI HAR Dataset/train/y_train.txt",header=FALSE)
train_subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt",header=FALSE)

test_x <- read.table("data/UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)
test_y <- read.table("data/UCI HAR Dataset/test/y_test.txt",sep="",header=FALSE)
test_subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt",header=FALSE)

activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt",header = FALSE)
colnames(activity_labels) <- c("activity_id","activity_name")

all_x <- rbind(train_x, test_x)
all_y <- rbind(train_y,test_y)
all_subject = rbind(train_subject,test_subject)
colnames(all_subject) <- c("subject")
colnames(all_y) <- c("activity_id")


# filter all x to standard devaition and mean columns and add descriptive headers
x_col_names <- read.table("data/UCI HAR Dataset/features.txt")
x_col_names_std_mean <- filter(x_col_names,grepl('std|mean', V2))
all_x_std_mean <- select(all_x,as.integer(x_col_names_std_mean$V1))
colnames(all_x_std_mean) <- x_col_names_std_mean$V2

# glue on activity id and activity description
all_x_std_mean_activity <- cbind(all_x_std_mean , all_y)
all_x_std_mean_activity_desc <- merge(all_x_std_mean_activity,activity_labels,all.x=TRUE)

#glue on subject
all_x_all_data <- cbind(all_x_std_mean_activity_desc,all_subject)

# Now create the tidy data outlined in the assignment
grouped <- group_by(all_x_all_data,activity_name,subject) %>%
            summarise_each(funs(mean))

write.table(grouped, file = "./tidy_data.txt", sep = " ",row.names = F)


