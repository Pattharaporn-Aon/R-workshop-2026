# =====================================================================
#  Practical Data Analysis and Forecasting with R
#  00_setup.R  -- run this ONCE before the workshop starts
# =====================================================================

# 1. Which version of R am I running?
R.version.string

# 2. Install the packages we need (only needed once per computer)
install.packages(c(
  "readxl",     # read Excel files
  "readr",      # read CSV files
  "dplyr",      # data manipulation
  "ggplot2",    # graphics
  "car",        # Levene's test
  "effectsize", # eta squared, Cohen's d
  "zoo",        # filling gaps in a time series
  "forecast"    # ARIMA and forecasting
))

# 3. Load them and check that nothing errors
library(readxl)
library(readr)
library(dplyr)
library(ggplot2)
library(car)
library(effectsize)
library(zoo)
library(forecast)

cat("All packages loaded. You are ready.\n")

# 4. Check that R can reach the workshop data on GitHub
# Every file is read straight from GitHub. No download and no setwd() needed.
data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"
students <- read_csv(paste0(data_url, "student_achievement.csv"))
dim(students)   # 300 rows, 10 columns

cat("Data loaded from GitHub. You are ready.\n")

# 5. Where is R saving your own files (figures, cleaned data)?
getwd()
