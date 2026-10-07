# =====================================================================
#  DAY 2 - MORNING
#  03_tests.R  -- t-tests, ANOVA, correlation, regression
# =====================================================================

library(readr)
library(ggplot2)
library(car)          # leveneTest()
library(effectsize)   # cohens_d(), eta_squared()

# Every file is read straight from GitHub. No download and no setwd() needed.
data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"

# The cleaned data produced at the end of 01_basics.R
students <- read_csv(paste0(data_url, "students_clean.csv"))
students$Method <- factor(students$Method,
                          levels = c("Traditional", "Blended", "Flipped"))

# ---------------------------------------------------------------- 3.1
# Check the assumptions BEFORE you choose the test
shapiro.test(students$Posttest)        # W = 0.99342, p = 0.2134
qqnorm(students$Posttest); qqline(students$Posttest, col = "red")

leveneTest(Posttest ~ Method, data = students)   # F = 0.5571, p = 0.5735

# ---------------------------------------------------------------- 3.2
# PAIRED t-test: the same students measured twice
t.test(students$Posttest, students$Pretest, paired = TRUE)
#   t = 32.186, df = 299, p < 2.2e-16
#   mean difference 17.21, 95% CI [16.16, 18.27]

cohens_d(students$Posttest, students$Pretest, paired = TRUE)   # dz = 1.86

# ---------------------------------------------------------------- 3.3
# INDEPENDENT t-test: two different groups of students
t.test(Posttest ~ Region, data = students)
#   t = -4.9595, df = 271.72, p = 1.2e-06
#   Rural 64.59  vs  Urban 70.78

cohens_d(Posttest ~ Region, data = students)   # d = -0.57

aggregate(Posttest ~ Region, data = students, FUN = mean)

# A non-significant example. Report it exactly as carefully.
t.test(Posttest ~ Gender, data = students)
#   t = -0.4023, df = 288.61, p = 0.6878  -> no evidence of a difference

# ---------------------------------------------------------------- 3.4
# ONE-WAY ANOVA: three or more groups
model1 <- aov(Posttest ~ Method, data = students)
summary(model1)
#   F(2, 297) = 8.133, p = 0.000364

eta_squared(model1)          # eta2 = 0.052  (a small-to-medium effect)

aggregate(Posttest ~ Method, data = students, FUN = mean)

# Which pairs actually differ?
TukeyHSD(model1)
plot(TukeyHSD(model1))

# ---------------------------------------------------------------- 3.5
# TWO-WAY ANOVA: two factors and their interaction
model2 <- aov(Posttest ~ Method * Region, data = students)
summary(model2)
#   Method        F = 8.329,  p = 0.000303
#   Region        F = 23.730, p = 1.97e-06
#   Method:Region F = 0.056,  p = 0.946   -> no interaction

# ---------------------------------------------------------------- 3.6
# CORRELATION
cor.test(students$StudyHours, students$Posttest)
#   r = 0.268, t = 4.794, df = 298, p = 2.6e-06

cor.test(students$Attendance, students$Posttest)
#   r = 0.045, p = 0.4403   -> not significant on its own

# All numeric variables at once
cor(students[, c("StudyHours", "Attendance", "Motivation",
                 "Pretest", "Posttest")])

# ---------------------------------------------------------------- 3.7
# LINEAR REGRESSION: several predictors together
model3 <- lm(Posttest ~ Pretest + StudyHours + Attendance, data = students)
summary(model3)
#   R-squared 0.436,  F(3, 296) = 76.33,  p < 2.2e-16

confint(model3)

# Diagnostics: four plots, one at a time
par(mfrow = c(2, 2))
plot(model3)
par(mfrow = c(1, 1))

# ---------------------------------------------------------------- 3.8
# EXERCISE
# 1. Test whether Motivation differs by Method (one-way ANOVA).
# 2. Run a paired t-test for the Flipped group only.
#    hint: subset(students, Method == "Flipped")
# 3. Add Method to model3 and see what happens to R-squared.
# 4. Write one sentence reporting each result in APA style.
