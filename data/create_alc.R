# Pauliina Anttila
# 17.11.2017
# Exercise 3, Data wrangling part, data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Reading both files (student-mat.csv and student-por.csv) into R:
mat <- read.csv(file="student-mat.csv", header = TRUE, sep = ";")
por <- read.csv(file="student-por.csv", header = TRUE, sep = ";")

#Exploring the structure and dimensions of the datasets:
str(mat) # 395 observations of 33 variables (variables include for example school, sex, age, address...)
dim(mat)
str(por) # 649 observations of 33 variables (includes the same variables with mat)
dim(por)

# Combining the 2 datasets with certain identifiers:
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
mat_por <- inner_join (mat, por, by = join_by)

str(mat_por) # 382 observations of 53 variables
dim(mat_por)

# Combining the duplicated answers:
library(dplyr)
colnames(mat_por)
alc <- select(mat_por, one_of(join_by))
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]
notjoined_columns

for(column_name in notjoined_columns) {
  two_columns <- select(mat_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- first_column
  }
}
glimpse(alc) # taking a quick glimpse at the variables

# Creating a new column alc_use:
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
# Creating a new column high_use:
alc <- mutate(alc, high_use = alc_use > 2)

# Taking a glimpse at the new data:
glimpse(alc) # 382 observations of 35 variables

# Saving the data as a csv-file:
write.csv(alc, file = "alc.csv", eol = "\n", na = "NA", row.names = FALSE)
test <- read.csv(file="alc.csv", header=TRUE, sep=",", dec=".")
str(test)
