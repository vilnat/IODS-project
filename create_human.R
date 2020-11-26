#Vilna Tyystjärvi
#Script for data wrangling for weeks 4 and 5 (Scroll down for Week 5)

#Considering the script name, is it time to discuss birds and bees?
#First, let's read some data:
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Let's check what's in the datasets
str(hd)
dim(hd)
summary(hd)
# So the first dataset contains information about countries and how they're doing based on the Human Development Index and some related variables

str(gii)
dim(gii)
summary(gii)
#And the same for gender equality

# I don't know if I was supposed to find some metafile giving out actual shorter variable names, so I just named these myself
colnames(hd)
library(dplyr)
hd <- hd %>% rename("hdiR" = "HDI.Rank", "country" = "Country", "hdi" = "Human.Development.Index..HDI.", "lifeExp_birth" = "Life.Expectancy.at.Birth", "eduExp" = "Expected.Years.of.Education", 
                    "meanEdu" = "Mean.Years.of.Education", "gni" = "Gross.National.Income..GNI..per.Capita", "gni_min_hdiR" = "GNI.per.Capita.Rank.Minus.HDI.Rank")
colnames(hd)

colnames(gii)
gii <- gii %>% rename("giiR" = "GII.Rank", "country" = "Country", "gii" = "Gender.Inequality.Index..GII.", "maternalMort" = "Maternal.Mortality.Ratio", "adolBirth" = "Adolescent.Birth.Rate", 
                      "parliament" = "Percent.Representation.in.Parliament", "edu2F" = "Population.with.Secondary.Education..Female.", "edu2M" = "Population.with.Secondary.Education..Male.",
                      "labourF" = "Labour.Force.Participation.Rate..Female.", "labourM" = "Labour.Force.Participation.Rate..Male.")

#Now we'll create two new variables by calculating the ration between women and men in education and workforce
gii$eduRatio <- gii$edu2F / gii$edu2M
gii$labourRatio <- gii$labourF / gii$labourM

#Let's join the datasets
human2 <- inner_join(hd, gii, by = "country")
head(human)
#Looks good enough

#And save
write.table(human, "data/human.csv")

##########################################################################
######                              #Week 5                         ######
##########################################################################
#Let's read the data and check what's inside
human <- read.table('data/human.csv')
str(human)
dim(human)
# The dataset consists of 19 variables and 195 observations (countries) describing the human 
# development index, gender inequality index and variables related to calculating those. These variables 
# are related to education, labour, life expectancy, standard of living etc.

#Something funny is going on with GNI
summary(human$gni)
#Some idiot decided it's a good idea to separate thousands with commas. Let's fix that.
library(stringr)
human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric
summary(human$gni)
#Much better

# Now let's get rid of some columns and rows with no data
keeps <- c("country", "eduRatio", "labourRatio", "eduExp", "lifeExp_birth", "gni", "maternalMort", "adolBirth", "parliament")
human <- human[keeps]
human <- na.omit(human)

tail(human, 10)
#Seems like Niger on row 188 is that last country in the dataset, the rest are larger regions. Let's remove them
last <- nrow(human) - 7
human <- human[1:last, ]
tail(human)

#And finally let's add country names as the index of the dataset rather than a column name
rownames(human) <- human$country
human <- dplyr::select(human, -country)
str(human)
head(human)

#And we'll save the new dataset
write.table(human, "data/human.csv")

testi <- read.table("data/human.csv")
head(testi)
