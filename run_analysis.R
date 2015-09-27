# download and unzip the file first in your work directory

# read the training dataset and the training activity and training subject datasets saved in their respective folders

tr = read.table("./UCI HAR Dataset/train/X_train.txt", sep="",header=FALSE)
tr1 = read.table("./UCI HAR Dataset/train/Y_train.txt", sep="")
tr2 = read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")

# read the test dataset and the test activity and test subject datasets saved in their respective folders

te = read.table("./UCI HAR Dataset/test/X_test.txt", sep="",header=FALSE)
te1 = read.table("./UCI HAR Dataset/test/Y_test.txt", sep="")
te2 = read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")

# read the features file and the activity mapping file
f = read.table("./UCI HAR Dataset/features.txt", sep="")
a = read.table("./UCI HAR Dataset/activity_labels.txt", sep="")

# add columns containing subject & activity information to the training dataset
ttt<-cbind(tr,tr1)
ttt1<-cbind(ttt,tr2)

# add columns containing subject & activity information to the training dataset
tee<-cbind(te,te1)
tee1<-cbind(tee,te2)
# append both training and test datasets into one consolidated dataset
mdata<-rbind(ttt1,tee1)
# read the features file and use it to give columns name in the consolidated dataset prepared above.

s<-f$V2
s<-as.character(s)
colnames(mdata)<-s
# rename the activity number and subject to make column name more intuitive
colnames(mdata)[562]<-"activity_number"
colnames(mdata)[563]<-"subject"
nrow(mdata)

#subset columns having mean/std and also take out id variables (activity_number & subject) 
#and combine both using cbind.

library(dplyr)

data2 <- mdata[,grepl("mean|std|Mean", colnames(mdata))]
data3<-mdata[,c("activity_number","subject")]
mdata1<-cbind(data2,data3)

#get the activity names and merge with the main file 
a$V2<-as.character(a$V2)
q1<-merge(mdata1, a,by.x="activity_number",by.y="V1",all.x = TRUE)
colnames(q1)[89]<-"activity_name"

#make the variables names as per R rules by replacing "-","(" & ")" by underscores"_".
names(q1)<-gsub("-","_",names(q1))
names(q1)<-gsub("\\(","_",names(q1))
names(q1)<-gsub("\\)","_",names(q1))

#calculate the mean of all variables for all combinations of subject & activity

final<-group_by(q1,subject,activity_name)%>% summarise_each(c("mean"))

# make the data more tidy by moving all column names under one variable called "variable" 
# and their values under variable "values"
va1 <- names(final[,!names(final) %in% c("subject", "activity_name", "activity_number")])
library(reshape2)
final_tidy <- melt(final, id=c("subject", "activity_name", "activity_number"), measure.vars = va1)

## write final tidy file as a text file.

write.table(final_tidy,file = "final_tidy.txt", row.names = FALSE)

##### final dataset can be read back in R using the following code
#file<-read.table(file = "final_tidy.txt",header = TRUE)
#file1<-dcast(file,subject+activity_number+activity_name~variable)