# =====================================================================
#  exercise3.R  -  Solutions to Exercise 3: Time series and forecasting
#  Practical Data Analysis and Forecasting with R
# =====================================================================

library(readr)
library(zoo)
library(forecast)

data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"

dir.create("figures", showWarnings = FALSE)

# =====================================================================
#  EXERCISE 3  -  Time series and forecasting  (Day 2 afternoon)
# =====================================================================

edu <- read_csv(paste0(data_url, "education_timeseries.csv"))
edu$Date <- as.Date(edu$Date)
edu$AttendanceRate <- na.approx(edu$AttendanceRate)

# --- 3.1 The whole workflow for EnrolmentIndex
sum(is.na(edu$EnrolmentIndex))
yE <- ts(edu$EnrolmentIndex, start = c(2015, 1), frequency = 12)
plot(yE, ylab = "Enrolment index", main = "Monthly enrolment, 2015-2024")
plot(decompose(yE))

# save both figures
png("figures/ex3_1a_enrolment_series.png", width = 7, height = 4.5, units = "in", res = 300)
plot(yE, ylab = "Enrolment index", main = "Monthly enrolment, 2015-2024")
dev.off()
png("figures/ex3_1b_enrolment_decomposition.png", width = 7, height = 7, units = "in", res = 300)
plot(decompose(yE))
dev.off()

trainE <- window(yE, end = c(2022, 12))
testE  <- window(yE, start = c(2023, 1))

edu$t      <- 1:nrow(edu)
edu$MonthF <- factor(edu$Month)
trE <- subset(edu, Date <  as.Date("2023-01-01"))
teE <- subset(edu, Date >= as.Date("2023-01-01"))

modelAE <- lm(EnrolmentIndex ~ t + MonthF, data = trE)
predAE  <- predict(modelAE, newdata = teE)
fitBE   <- snaive(trainE, h = 24)

accuracy(ts(predAE, start = c(2023, 1), frequency = 12), testE)
accuracy(fitBE, testE)

# --- 3.2 Move the split: train 2015-2021, test 2022-2024
y <- ts(edu$AttendanceRate, start = c(2015, 1), frequency = 12)
train2 <- window(y, end = c(2021, 12))
test2  <- window(y, start = c(2022, 1))
tr2 <- subset(edu, Date <  as.Date("2022-01-01"))
te2 <- subset(edu, Date >= as.Date("2022-01-01"))

modelA2 <- lm(AttendanceRate ~ t + MonthF, data = tr2)
predA2  <- predict(modelA2, newdata = te2)
fitB2   <- snaive(train2, h = 36)

accuracy(ts(predA2, start = c(2022, 1), frequency = 12), test2)
accuracy(fitB2, test2)

# --- 3.3 Remove 2020 from the training data and refit Model A
tr  <- subset(edu, Date <  as.Date("2023-01-01"))
te  <- subset(edu, Date >= as.Date("2023-01-01"))
test <- window(y, start = c(2023, 1))

modelA      <- lm(AttendanceRate ~ t + MonthF, data = tr)
modelA_no20 <- lm(AttendanceRate ~ t + MonthF, data = subset(tr, Year != 2020))

coef(modelA)["t"]          # trend with 2020
coef(modelA_no20)["t"]     # trend without 2020

accuracy(ts(predict(modelA,      newdata = te), start = c(2023, 1), frequency = 12), test)
accuracy(ts(predict(modelA_no20, newdata = te), start = c(2023, 1), frequency = 12), test)

# --- 3.4 Forecast 24 months instead of 12
modelFull <- lm(AttendanceRate ~ t + MonthF, data = edu)
future24  <- data.frame(t = 121:144,
                        MonthF = factor(rep(1:12, 2), levels = 1:12))
fc24 <- predict(modelFull, newdata = future24, interval = "prediction")
round(fc24, 2)
round(fc24[, "upr"] - fc24[, "lwr"], 2)     # width of each interval

# compare: ARIMA intervals widen as the horizon grows
fcA <- forecast(auto.arima(y), h = 24)
png("figures/ex3_4_arima_24_months.png", width = 7, height = 4.5, units = "in", res = 300)
plot(fcA, ylab = "Attendance rate (%)", main = "ARIMA forecast, 24 months")
dev.off()
