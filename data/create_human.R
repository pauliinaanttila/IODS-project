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
colnames(hd)[5] <- "Exp.Years"
colnames(hd)[6] <- "Edu.Years"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI_HDI"
str(hd)

colnames(gii)[1] <- "GII_rank"
colnames(gii)[2] <- "Country"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mat.Mort."
colnames(gii)[5] <- "Adol.Birth"
colnames(gii)[6] <- "Parliament"
colnames(gii)[7] <- "Sec.Edu.F"
colnames(gii)[8] <- "Sec.Edu.M"
colnames(gii)[9] <- "Labour.Force.F"
colnames(gii)[10] <- "Labour.Force.M"
str(gii)

# Creating two new variables to "Gender inequality" data:
gii <- mutate(gii, Sec.Edu.RatioFM = Sec.Edu.F / Sec.Edu.M) # creating a variable: the ratio of female and male populations with secondary education
gii <- mutate(gii, Labour.Force.RatioFM = Labour.Force.F / Labour.Force.M) # creating a variable: the ratio of labour force participation of females and males

# Joining the two datasets together:

human <- inner_join(hd, gii, by = "Country") # datasets joined using the variable 'Country', keeping only the countries in both datasets
str(human) # 195 observations of 19 variables

# Writing a CSV and testing that it works:
write.csv(human, file = "human.csv", row.names = FALSE)
human <- read.csv(file = "human.csv", header = TRUE, sep = ",", dec = ".")
str(human)
