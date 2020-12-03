#Vilna Tyystjärvi
#Script for data wrangling for week 6

#First, let's read some data:

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

str(BPRS)
summary(BPRS)

str(RATS)
summary(RATS)

#2 - Categorical data
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#3- Gather to long format
library(tidyr)
library(dplyr)
BPRSL <-  BPRS %>% 
  gather(key = weeks, value = bprs, -treatment, -subject) %>% 
  mutate(week = as.integer(substr(weeks, 5,5)))


RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3,4))) 

#4 - staring angrily at the data to understand it
head(BPRSL)
head(BPRS)

head(RATS)
head(RATSL)

str(RATSL)

#I don't know what else I need to do here. Point of the long format is to gather the data so that 
# you can also use the "column name" of wide format as a a variable which can be useful. 

write.table(RATSL, "data/rats_long.csv")
write.table(BPRSL, "data/bprs_long.csv")
