# =====================================================================
#  DAY 2 - AFTERNOON
#  04_timeseries.R  -- cross-sectional vs time series, and forecasting
# =====================================================================

library(readr)
library(ggplot2)
library(zoo)        # na.approx()
library(forecast)   # auto.arima(), accuracy()

# Every file is read straight from GitHub. No download and no setwd() needed.
data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"
edu <- read_csv(paste0(data_url, "education_timeseries.csv"))
edu$Date <- as.Date(edu$Date)

str(edu)
head(edu)
dim(edu)            # 120 rows = 120 months, Jan 2015 to Dec 2024

# ---------------------------------------------------------------- 4.1
# Gaps: the sensor failed, the form was never returned, the file was lost
sum(is.na(edu$AttendanceRate))          # 3
which(is.na(edu$AttendanceRate))        # rows 30, 64, 95

ggplot(edu, aes(x = Date, y = AttendanceRate)) + geom_line()

# Fill them by linear interpolation between the neighbouring months
edu$AttendanceRate <- na.approx(edu$AttendanceRate)
sum(is.na(edu$AttendanceRate))          # 0

# ---------------------------------------------------------------- 4.2
# A ts object knows its own calendar
y <- ts(edu$AttendanceRate, start = c(2015, 1), frequency = 12)
y
start(y); end(y); frequency(y)

plot(y, ylab = "Attendance rate (%)", main = "Monthly attendance, 2015-2024")

# ---------------------------------------------------------------- 4.3
# Split the series into its parts
decomp <- decompose(y)
plot(decomp)

# How strongly does this month depend on earlier months?
acf(y, lag.max = 36)

# ---------------------------------------------------------------- 4.4
# NEVER split a time series at random. Time order is the information.
train <- window(y, start = c(2015, 1), end = c(2022, 12))   # 96 months
test  <- window(y, start = c(2023, 1))                       # 24 months
length(train); length(test)

train_df <- subset(edu, Date <  as.Date("2023-01-01"))
test_df  <- subset(edu, Date >= as.Date("2023-01-01"))

# ---------------------------------------------------------------- 4.5
# MODEL A: linear trend plus a monthly seasonal effect
train_df$t      <- 1:nrow(train_df)
train_df$MonthF <- factor(train_df$Month)
test_df$t       <- (nrow(train_df) + 1):nrow(edu)
test_df$MonthF  <- factor(test_df$Month)

modelA <- lm(AttendanceRate ~ t + MonthF, data = train_df)
summary(modelA)
#   trend  t = 0.02034 per month  (about +0.24 points per year)
#   R-squared 0.540,  residual sd 1.199

predA <- predict(modelA, newdata = test_df)

# ---------------------------------------------------------------- 4.6
# MODEL B: seasonal naive -- "the same month last year". The baseline.
fitB  <- snaive(train, h = 24)
predB <- as.numeric(fitB$mean)

# ---------------------------------------------------------------- 4.7
# Which one is closer to what actually happened?
accuracy(ts(predA, start = c(2023, 1), frequency = 12), test)
accuracy(fitB, test)

#   model              RMSE     MAE     MAPE
#   trend + season    1.2505  1.1192   1.23 %
#   seasonal naive    1.1734  0.8656   0.95 %
#
#   The simple baseline wins. Always fit the baseline first.

# ---------------------------------------------------------------- 4.8
# MODEL C: let R choose the ARIMA structure for you
modelC <- auto.arima(train)
modelC
fcC <- forecast(modelC, h = 24)
plot(fcC)
accuracy(fcC, test)

# ---------------------------------------------------------------- 4.9
# Automated preprocessing with atspR
# (gap filling, outlier handling and feature building in one step)
#
# install.packages("devtools")
# devtools::install_github("<your-github-account>/atspR")
#
# library(atspR)
# clean <- atsp_prepare(edu, date = "Date", value = "AttendanceRate")
# fit   <- atsp_forecast(clean, h = 12)
# plot(fit)

# ---------------------------------------------------------------- 4.10
# Refit on ALL the data and forecast the next 12 months
edu$t      <- 1:nrow(edu)
edu$MonthF <- factor(edu$Month)
modelFull  <- lm(AttendanceRate ~ t + MonthF, data = edu)

future <- data.frame(t = 121:132, MonthF = factor(1:12, levels = 1:12))
fc     <- predict(modelFull, newdata = future, interval = "prediction")
round(fc, 2)
#   Jan 2025  89.58  [87.12, 92.05]
#   Sep 2025  93.11  [90.65, 95.57]

# ---------------------------------------------------------------- 4.11
# EXERCISE
# 1. Repeat the whole workflow for EnrolmentIndex.
# 2. Change the split to train = 2015-2021, test = 2022-2024.
#    Do the accuracy numbers change a lot?
# 3. Remove the year 2020 from the training data and refit modelA.
# 4. Forecast 24 months ahead instead of 12 and describe what widens.
