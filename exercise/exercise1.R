# =====================================================================
#  exercise1.R  -  Solutions to Exercise 1: Figures with ggplot2
#  Practical Data Analysis and Forecasting with R
# =====================================================================

library(readr)
library(ggplot2)

data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"
students <- read_csv(paste0(data_url, "students_clean.csv"))
students$Method <- factor(students$Method,
                          levels = c("Traditional", "Blended", "Flipped"))

dir.create("figures", showWarnings = FALSE)

# =====================================================================
#  EXERCISE 1  -  Figures with ggplot2  (Day 1 afternoon)
# =====================================================================

# --- 1.1 Boxplot of Posttest by Region, no legend
ggplot(students, aes(x = Region, y = Posttest, fill = Region)) +
  geom_boxplot() +
  theme(legend.position = "none")
ggsave("figures/ex1_1_boxplot_region.png", width = 7, height = 4.5, dpi = 300)

# --- 1.2 Scatter coloured by Gender, then faceted by Method
ggplot(students, aes(x = StudyHours, y = Posttest, colour = Gender)) +
  geom_point(size = 2)
ggsave("figures/ex1_2a_scatter_gender.png", width = 7, height = 4.5, dpi = 300)

ggplot(students, aes(x = StudyHours, y = Posttest, colour = Gender)) +
  geom_point(size = 2) +
  facet_wrap(~ Method)
ggsave("figures/ex1_2b_scatter_gender_by_method.png", width = 9, height = 4, dpi = 300)

# --- 1.3 Histograms of Pretest and Posttest, same binwidth and x limits
ggplot(students, aes(x = Pretest)) +
  geom_histogram(binwidth = 5, fill = "grey60", colour = "white") +
  scale_x_continuous(limits = c(25, 100))
ggsave("figures/ex1_3a_histogram_pretest.png", width = 7, height = 4.5, dpi = 300)

ggplot(students, aes(x = Posttest)) +
  geom_histogram(binwidth = 5, fill = "grey60", colour = "white") +
  scale_x_continuous(limits = c(25, 100))
ggsave("figures/ex1_3b_histogram_posttest.png", width = 7, height = 4.5, dpi = 300)

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

ggsave("figures/ex1_4_final_figure.png", width = 7, height = 4.5, dpi = 300)

# --- Extra: fixed y axis limits
ggplot(students, aes(x = Region, y = Posttest, fill = Region)) +
  geom_boxplot() +
  scale_y_continuous(limits = c(30, 100))
ggsave("figures/ex1_extra_ylimits.png", width = 7, height = 4.5, dpi = 300)

