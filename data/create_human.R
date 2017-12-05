# Exercise 4, Data wrangling part
# Data sources: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv, http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv
# Pauliina Anttila
# 27.11.2017

# Reading the datasets into R:
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Exploring the datasets:
dim(hd) # 195 observations of 8 variables
str(hd) # The variables are HDI.Rank, Country, Human.Development.Index., Life.Expectancy.at.Birth, Expected.Years.of.Education, Mean.Years.of.Education, Gross.National.Income.GNI.per.Capita and GNI.per.Capita.Rank.Minus.HDI.Rank.
dim(gii) # 195 observations of 10 variables
str(gii) # The variables are GII.Rank, Country, Gender.Inequality.Index.GII, Maternal.Mortality.Ratio, Adolescent.Birth.Rate, Percent.Representation.in.Parliament, Population.with.Secondary.Education.Female, Population.with.Secondary.Education.Male, Labour.Force.Participation.Rate.Female and Labour.Force.Participation.Rate.Male.
summary(hd) # HDI rank varies between 1-188 (mean 94.3)...
summary(gii) # GII rank varies between 1-188 (mean 94.3)...

# Renaming the variables:
colnames(hd)[1] <- "HDI_rank"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "Life.Exp"
colnames(hd)[5] <- "Edu.Exp"
colnames(hd)[6] <- "Edu.Years"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI_HDI"
str(hd)

colnames(gii)[1] <- "GII_rank"
colnames(gii)[2] <- "Country"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mat.Mor"
colnames(gii)[5] <- "Ado.Birth"
colnames(gii)[6] <- "Parli.F"
colnames(gii)[7] <- "Edu2.F"
colnames(gii)[8] <- "Edu2.M"
colnames(gii)[9] <- "Labo.F"
colnames(gii)[10] <- "Labo.M"
str(gii)

# Creating two new variables to "Gender inequality" data:
gii <- mutate(gii, Edu2.FM = Edu2.F / Edu2.M) # creating a variable: the ratio of female and male populations with secondary education
gii <- mutate(gii, Labo.FM = Labo.F / Labo.M) # creating a variable: the ratio of labour force participation of females and males

# Joining the two datasets together:

human <- inner_join(hd, gii, by = "Country") # datasets joined using the variable 'Country', keeping only the countries in both datasets
str(human) # 195 observations of 19 variables

# Writing a CSV and testing that it works:
write.csv(human, file = "human.csv", row.names = FALSE)
human <- read.csv(file = "human.csv", header = TRUE, sep = ",", dec = ".")
str(human)

# Exercise 5, Data wrangling part
# 4.12.2017

# Mutating the data so that GNI variable is transformed to numeric (GNInum):
library(dplyr)
library(stringr)
GNInum <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
human <- mutate(human, GNInum) # adding the 'GNInum' variable to 'human' data
human <- dplyr::select(human, -GNI) # taking the 'GNI' variable out of the 'human' data

# Excluding unneeded variables:
keep_columns = c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNInum", "Mat.Mor", "Ado.Birth", "Parli.F")
human_selected <- dplyr::select(human, one_of(keep_columns))

# Removing all rows with missing values:
complete.cases(human_selected)
data.frame(human.selected[-1], comp = complete.cases(human_selected))
human_ <- filter(human_selected, complete.cases(human_selected))

# Removing the observations which relate to regions instead of countries (last 7 observations):
tail(human_, n= 20)
last <- nrow(human_) - 7
human_ <- human_[1:last, ]

# Defining the row names of the data by the country names and removing the country name column from the data:
rownames(human_) <- human_$Country
human_ <- dplyr::select(human_, -Country)
str(human_) # 155 observations of 8 variables

# Saving the data including the row names:
write.csv(human_, file ="human.csv", row.names = TRUE)
human_ <-read.csv(file = "human.csv", header = TRUE, sep = ",", dec = ".", row.names=1)
View(human_)
