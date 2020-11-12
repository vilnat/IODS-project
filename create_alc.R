# Vilna Tyystjärvi
# 12.11.2020
# This is the R script for Week 3 exercise
# Data downloaded from: https://archive.ics.uci.edu/ml/machine-learning-databases/00320/

library(dplyr)

#Let's set the working directory
setwd("~/IODS-project/data/")

#read and check the data
mat <- read.table("student-mat.csv", sep = ";", header = TRUE)
str(mat)
dim(mat)

por <- read.table("student-por.csv", sep = ";", header = TRUE)
str(por)
dim(por)

#select columns to be used in joining the datasets
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(mat, por, by = join_by, suffix = c(".math", ".por"))
str(math_por)
dim(math_por)

#Let's create a new dataset by combining duplicated questions (via the lazy way, it's 10 in the evening)
alc <- select(math_por, one_of(join_by))
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

head(alc)

#Let's calculate alcohol usage
alc$alc_use <- (alc$Dalc + alc$Walc) / 2
alc$high_use <- alc$alc_use > 2

#Check everything's in order
glimpse(alc)
dim(alc)

#And save the data
write.table(alc, "alcohol_is_bad.csv", sep = ";")
