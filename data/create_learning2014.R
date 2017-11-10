# Pauliina Anttila, 9.11.2017, Data wrangling exercise, data source http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = TRUE)
str(learning2014)
dim(learning2014)
# In the data, there is 183 observations (rows) and 60 variables (columns). The variables include for example age, attitude, points and gender.
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
# Questions of the same theme combined
install.packages("dplyr")
library(dplyr)
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)
surf_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surf_columns)
stra_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(stra_columns)
# rowMeans calculated for deep, surf and stra
colnames(learning2014)
colnames(learning2014)[57] <- "age"
colnames(learning2014)[58] <- "attitude"
colnames(learning2014)[59] <- "points"
# column names changed
keep_columns <- c("gender", "age", "attitude", "deep", "stra", "surf", "points")
learning2014_analysis <- select(learning2014, one_of(keep_columns))
# columns necessary for the analysis chosen
str(learning2014_analysis)
learning2014_analysis <- filter(learning2014_analysis, points >0)
# points = 0 removed
str(learning2014_analysis)
write.csv(learning2014_analysis, file = "learning2014.csv", eol = "\r", na = "NA", row.names = FALSE)
lrng2014 <- read.csv(file = "learning2014.csv", header = TRUE, sep = ",")
str(lrng2014)
head(lrng2014)
View(lrng2014)
