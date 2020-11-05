# Vilna Tyystjärvi
# 5.11.2020
# This is the R script for Week 2 exercise

library(dplyr)

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = TRUE)
dim(lrn14)
str(lrn14)

#The table consists of 60 columns and 183 rows. All columns besides one contain integers. 
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
learning2014 <- lrn14[keep_columns]
learning2014$Attitude <- learning2014$Attitude / 10
learning2014 <- filter(learning2014, Points > 0)

colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"
dim(learning2014)

setwd("~/IODS-project/")

write.table(learning2014, "data/learning2014.csv")

testi <- read.table("data/learning2014.csv")
head(testi)
dim(testi)

write.csv(learning2014, "data/testi.csv")
t <- read.csv("data/testi.csv")
head(t)
#So write.csv includes index column but ride.table doesn't. Never noticed that before.