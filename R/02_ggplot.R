# =====================================================================
#  DAY 1 - AFTERNOON
#  02_ggplot.R  -- turning the table into figures with ggplot2
# =====================================================================

library(readr)
library(ggplot2)

# Every file is read straight from GitHub. No download and no setwd() needed.
data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"

# The cleaned data produced at the end of 01_basics.R
students <- read_csv(paste0(data_url, "students_clean.csv"))

# Put the three methods in a sensible order for every plot
students$Method <- factor(students$Method,
                          levels = c("Traditional", "Blended", "Flipped"))

# ---------------------------------------------------------------- 2.1
# Every ggplot has three parts: data, aes(), and at least one geom_
ggplot(students, aes(x = Posttest)) +
  geom_histogram(binwidth = 5, fill = "#4C72B0", colour = "white")

# ---------------------------------------------------------------- 2.2
# Boxplot: distribution of one numeric variable inside each group
ggplot(students, aes(x = Method, y = Posttest, fill = Method)) +
  geom_boxplot()

# ---------------------------------------------------------------- 2.3
# Scatter plot with a fitted straight line and its confidence band
ggplot(students, aes(x = StudyHours, y = Posttest)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm")

# ---------------------------------------------------------------- 2.4
# Colour by a third variable
ggplot(students, aes(x = StudyHours, y = Posttest, colour = Method)) +
  geom_point(size = 2)

# ---------------------------------------------------------------- 2.5
# Small multiples: one panel per region
ggplot(students, aes(x = StudyHours, y = Posttest, colour = Method)) +
  geom_point(size = 2) +
  facet_wrap(~ Region)

# ---------------------------------------------------------------- 2.6
# Bar chart of group means with 95% confidence intervals
ggplot(students, aes(x = Method, y = Posttest, fill = Method)) +
  stat_summary(fun = mean, geom = "bar", width = 0.6) +
  stat_summary(fun.data = mean_se, fun.args = list(mult = 1.96),
               geom = "errorbar", width = 0.15)

# ---------------------------------------------------------------- 2.7
# Two densities on one panel: before and after
ggplot(students) +
  geom_density(aes(x = Pretest),  fill = "#F8766D", alpha = 0.45) +
  geom_density(aes(x = Posttest), fill = "#00BFC4", alpha = 0.45) +
  labs(x = "Score", y = "density")

# ---------------------------------------------------------------- 2.8
# A line chart needs the time series file
edu <- read_csv(paste0(data_url, "education_timeseries.csv"))
edu$Date <- as.Date(edu$Date)

ggplot(edu, aes(x = Date, y = AttendanceRate)) +
  geom_line(colour = "#2C7FB8", linewidth = 0.8)

# ---------------------------------------------------------------- 2.9
# Labels: never present a figure with variable names as axis titles
ggplot(students, aes(x = Method, y = Posttest, fill = Method)) +
  geom_boxplot() +
  labs(title    = "Posttest achievement by teaching method",
       subtitle = "Six schools, n = 300 students",
       x        = "Teaching method",
       y        = "Posttest score (0-100)",
       caption  = "Source: workshop dataset, 2026")

# ---------------------------------------------------------------- 2.10
# Themes change everything that is not data
p <- ggplot(students, aes(x = Method, y = Posttest, fill = Method)) +
  geom_boxplot()

p + theme_minimal()
p + theme_classic()
p + theme_bw()

# ---------------------------------------------------------------- 2.11
# Choose your own colours. Grey scales survive black-and-white printing.
ggplot(students, aes(x = Method, y = Posttest, fill = Method)) +
  geom_boxplot() +
  scale_fill_manual(values = c("#D9D9D9", "#A6A6A6", "#737373")) +
  labs(x = "Teaching method", y = "Posttest score") +
  theme_classic() +
  theme(legend.position = "none")

# ---------------------------------------------------------------- 2.12
# Save at a resolution a journal will accept
ggsave("figure1_method.png", width = 7, height = 4.5, dpi = 300)
ggsave("figure1_method.tiff", width = 7, height = 4.5, dpi = 300)

# ---------------------------------------------------------------- 2.13
# EXERCISE
# 1. Draw a boxplot of Posttest by Region.
# 2. Colour the points of 2.3 by Gender instead of Method.
# 3. Facet 2.3 by Method instead of Region.
# 4. Give your best figure a full set of labels and save it at 300 dpi.
