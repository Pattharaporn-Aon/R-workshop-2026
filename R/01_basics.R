# =====================================================================
#  DAY 1 - MORNING
#  01_basics.R  -- first commands, objects, importing, cleaning
# =====================================================================

# ---------------------------------------------------------------- 1.1
# Your first commands
print("Hello Kazakhstan")
1 + 1
25 * 4
sqrt(144)

# ---------------------------------------------------------------- 1.2
# Storing values. The arrow <- is the R convention.
Name  <- "Aigerim"
Score <- 78
Score
Name

class(Name)     # "character"
class(Score)    # "numeric"
str(Score)      # num 78

# ---------------------------------------------------------------- 1.3
# Vectors: many values of one type, built with c()
Marks <- c(72, 65, 80, 58, 91)
Marks
Marks[1]        # first value
Marks[2:4]      # values 2 to 4  (R counts from 1, not 0)
length(Marks)

mean(Marks)
sd(Marks)
min(Marks)
max(Marks)
summary(Marks)

# Vectors are arithmetic-friendly
Marks + 5
Marks / 10

# ---------------------------------------------------------------- 1.4
# Factors: categorical variables
Group <- factor(c("Urban", "Rural", "Urban", "Urban", "Rural"))
Group
levels(Group)
table(Group)

# ---------------------------------------------------------------- 1.5
# Data frames: a table. Rows = observations, columns = variables.
demo <- data.frame(
  Student = c("A", "B", "C", "D", "E"),
  Region  = Group,
  Mark    = Marks
)
demo
demo$Mark          # one column
demo[1, ]          # one row
demo[demo$Region == "Urban", ]

# ---------------------------------------------------------------- 1.6
# Getting help
?mean
help(sd)

# =====================================================================
#  IMPORTING THE REAL DATASET
# =====================================================================

library(readr)
library(readxl)

# Every file is read straight from GitHub. No download and no setwd() needed.
data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"
students <- read_csv(paste0(data_url, "student_achievement.csv"))

# The Excel version of exactly the same data.
# read_excel() cannot read a web address, so download the file first:
# download.file(paste0(data_url, "student_achievement.xlsx"),
#               "student_achievement.xlsx", mode = "wb")
# students <- read_excel("student_achievement.xlsx")

# Working offline? Put the file in your working folder and use:
# students <- read_csv("student_achievement.csv")

# ---------------------------------------------------------------- 1.7
# Always inspect before you analyse
head(students)
dim(students)          # 300 rows, 10 columns
names(students)
str(students)
summary(students)

table(students$Method)
table(students$Region)
table(students$Gender)

# =====================================================================
#  DATA QUALITY: never analyse data you have not checked
# =====================================================================

# ---------------------------------------------------------------- 1.8
# How many missing values in each column?
colSums(is.na(students))
#   StudyHours = 6,  Motivation = 4

# Are there impossible values? Attendance is a percentage.
range(students$Attendance, na.rm = TRUE)
students[students$Attendance > 100, c("StudentID", "Attendance")]

# ---------------------------------------------------------------- 1.9
# Step 1: turn impossible values into NA
students$Attendance[students$Attendance > 100] <- NA

# Step 2: replace every NA with the median of that column
students$StudyHours[is.na(students$StudyHours)] <-
  median(students$StudyHours, na.rm = TRUE)
students$Attendance[is.na(students$Attendance)] <-
  median(students$Attendance, na.rm = TRUE)
students$Motivation[is.na(students$Motivation)] <-
  median(students$Motivation, na.rm = TRUE)

# Step 3: check that the cleaning worked
colSums(is.na(students))
summary(students$Attendance)

# Save the cleaned version on your own computer
write.csv(students, "students_clean.csv", row.names = FALSE)
# The same cleaned file is also on GitHub, so 02 and 03 run on their own.
