# =====================================================================
#  exercise2.R  -  Solutions to Exercise 2: Statistical tests
#  Practical Data Analysis and Forecasting with R
# =====================================================================

library(readr)
library(effectsize)

data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"
students <- read_csv(paste0(data_url, "students_clean.csv"))
students$Method <- factor(students$Method,
                          levels = c("Traditional", "Blended", "Flipped"))

# =====================================================================
#  EXERCISE 2  -  Statistical tests  (Day 2 morning)
# =====================================================================

# --- 2.1 Does Motivation differ by Method?
modelM <- aov(Motivation ~ Method, data = students)
summary(modelM)
eta_squared(modelM)
TukeyHSD(modelM)
aggregate(Motivation ~ Method, data = students, FUN = mean)

# --- 2.2 Paired t-test for the Flipped group only
flipped <- subset(students, Method == "Flipped")
t.test(flipped$Posttest, flipped$Pretest, paired = TRUE)
cohens_d(flipped$Posttest, flipped$Pretest, paired = TRUE)

# compare with the whole sample
t.test(students$Posttest, students$Pretest, paired = TRUE)

# --- 2.3 Add Method to model3
model3 <- lm(Posttest ~ Pretest + StudyHours + Attendance, data = students)
model4 <- lm(Posttest ~ Pretest + StudyHours + Attendance + Method,
             data = students)
summary(model3)$r.squared
summary(model4)$r.squared
summary(model4)
anova(model3, model4)      # does adding Method improve the model?

