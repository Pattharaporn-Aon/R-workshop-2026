# =====================================================================
#  05_solutions.R  -  Solutions to Exercises 1, 2 and 3
#  Practical Data Analysis and Forecasting with R
# =====================================================================

library(readr)
library(dplyr)
library(ggplot2)
library(effectsize)
library(zoo)
library(forecast)

data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"
students <- read_csv(paste0(data_url, "students_clean.csv"))
students$Method <- factor(students$Method,
                          levels = c("Traditional", "Blended", "Flipped"))

# =====================================================================
#  EXERCISE 1  -  Figures with ggplot2  (Day 1 afternoon)
# =====================================================================

# --- 1.1 Boxplot of Posttest by Region, no legend
ggplot(students, aes(x = Region, y = Posttest, fill = Region)) +
  geom_boxplot() +
  theme(legend.position = "none")

# --- 1.2 Scatter coloured by Gender, then faceted by Method
ggplot(students, aes(x = StudyHours, y = Posttest, colour = Gender)) +
  geom_point(size = 2)

ggplot(students, aes(x = StudyHours, y = Posttest, colour = Gender)) +
  geom_point(size = 2) +
  facet_wrap(~ Method)

# --- 1.3 Histograms of Pretest and Posttest, same binwidth and x limits
ggplot(students, aes(x = Pretest)) +
  geom_histogram(binwidth = 5, fill = "grey60", colour = "white") +
  scale_x_continuous(limits = c(25, 105))

ggplot(students, aes(x = Posttest)) +
  geom_histogram(binwidth = 5, fill = "grey60", colour = "white") +
  scale_x_continuous(limits = c(25, 105))

# --- 1.4 A fully labelled figure, saved at 300 dpi
ggplot(students, aes(x = Region, y = Posttest, fill = Region)) +
  geom_boxplot() +
  scale_fill_manual(values = c("#D9D9D9", "#737373")) +
  labs(title    = "Posttest achievement by region",
       subtitle = "Six schools, n = 300 students",
       x        = "Region",
       y        = "Posttest score (0-100)") +
  theme_classic() +
  theme(legend.position = "none")

ggsave("exercise1_region.png", width = 7, height = 4.5, dpi = 300)

# --- Extra: fixed y axis limits
ggplot(students, aes(x = Region, y = Posttest, fill = Region)) +
  geom_boxplot() +
  scale_y_continuous(limits = c(30, 100))

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

# =====================================================================
#  EXERCISE 3  -  Time series and forecasting  (Day 2 afternoon)
#  Same steps and object names as the lesson slides
# =====================================================================

edu <- read_csv(paste0(data_url, "education_timeseries.csv"))
edu$Date <- as.Date(edu$Date)
edu$AttendanceRate <- na.approx(edu$AttendanceRate)
y <- ts(edu$AttendanceRate, start = c(2015, 1), frequency = 12)

train_df <- subset(edu, Date <  as.Date("2023-01-01"))
test_df  <- subset(edu, Date >= as.Date("2023-01-01"))
test     <- window(y, start = c(2023, 1))

# --- 3.1 The whole workflow for EnrolmentIndex
# same steps as the lesson, one column changed
yE <- ts(edu$EnrolmentIndex, start = c(2015, 1), frequency = 12)
plot(yE)
plot(decompose(yE))

trainE <- window(yE, start = c(2015, 1), end = c(2022, 12))
testE  <- window(yE, start = c(2023, 1))

train_df$t <- 1:nrow(train_df);   train_df$MonthF <- factor(train_df$Month)
test_df$t  <- (nrow(train_df) + 1):nrow(edu)
test_df$MonthF <- factor(test_df$Month)

modelAE <- lm(EnrolmentIndex ~ t + MonthF, data = train_df)
predAE  <- predict(modelAE, newdata = test_df)
fitBE   <- snaive(trainE, h = 24)
predBE  <- as.numeric(fitBE$mean)

accuracy(predAE, testE)   
accuracy(predBE, testE)

# --- 3.2 Move the split: train 2015-2021, test 2022-2024
train2 <- window(y, start = c(2015, 1), end = c(2021, 12))   # 84 months
test2  <- window(y, start = c(2022, 1))                      # 36 months
train2_df <- subset(edu, Date <  as.Date("2022-01-01"))
test2_df  <- subset(edu, Date >= as.Date("2022-01-01"))

train2_df$t <- 1:nrow(train2_df);  train2_df$MonthF <- factor(train2_df$Month)
test2_df$t  <- (nrow(train2_df) + 1):nrow(edu)
test2_df$MonthF <- factor(test2_df$Month)

modelA2 <- lm(AttendanceRate ~ t + MonthF, data = train2_df)
predA2  <- predict(modelA2, newdata = test2_df)
fitB2   <- snaive(train2, h = 36)
predB2  <- as.numeric(fitB2$mean)

accuracy(predA2, test2)   
accuracy(predB2, test2)

# --- 3.3 Remove 2020 from the training data and refit Model A
# train_df and test_df as in the lesson (t and MonthF already added)
modelA      <- lm(AttendanceRate ~ t + MonthF, data = train_df)
modelA_no20 <- lm(AttendanceRate ~ t + MonthF,
                  data = subset(train_df, Year != 2020))

coef(modelA)["t"]         
coef(modelA_no20)["t"]    

predA      <- predict(modelA,      newdata = test_df)
predA_no20 <- predict(modelA_no20, newdata = test_df)

accuracy(predA,      test)   
accuracy(predA_no20, test)

# --- 3.4 Forecast 24 months instead of 12
# refit on all data, as in the lesson
edu$t      <- 1:nrow(edu)
edu$MonthF <- factor(edu$Month)
modelFull  <- lm(AttendanceRate ~ t + MonthF, data = edu)

future24 <- data.frame(t = 121:144,
                       MonthF = factor(rep(1:12, 2), levels = 1:12))
fc24 <- predict(modelFull, newdata = future24, interval = "prediction")
round(fc24, 2)
round(fc24[, "upr"] - fc24[, "lwr"], 2)   

# compare: ARIMA
fcA <- forecast(auto.arima(y), h = 24)
plot(fcA)
fcA$upper[, 2] - fcA$lower[, 2]
