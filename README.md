# Practical Data Analysis and Forecasting with R
### for Social and Educational Research — two-day workshop materials

Pattharaporn Thongnim · Department of Mathematics, Faculty of Science, Burapha University

Every script reads its data directly from this repository. Open a script in
RStudio and run it. There is nothing to download and no `setwd()` to set.

## Quick start

1. Install R and RStudio (slides 6–7).
2. Run the setup script once. It installs the packages and checks that R can reach the data:

   ```r
   source("https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/R/00_setup.R")
   ```

3. Open each script below in RStudio (click the file, then **Raw**, and copy it into a new
   R script), or take everything at once with **Code → Download ZIP** on this page.

## What is here

| File | Session |
|---|---|
| [`R/00_setup.R`](R/00_setup.R) | Before the workshop — package installation |
| [`R/01_basics.R`](R/01_basics.R) | Day 1 morning — first commands, importing, cleaning |
| [`R/02_ggplot.R`](R/02_ggplot.R) | Day 1 afternoon — figures with ggplot2 |
| [`R/03_tests.R`](R/03_tests.R) | Day 2 morning — t-tests, ANOVA, correlation, regression |
| [`R/04_timeseries.R`](R/04_timeseries.R) | Day 2 afternoon — time series and forecasting |
| [`data/student_achievement.csv`](data/student_achievement.csv) | Cross-sectional data, Day 1 and Day 2 morning |
| [`data/student_achievement.xlsx`](data/student_achievement.xlsx) | The same data, for the Excel import demonstration |
| [`data/students_clean.csv`](data/students_clean.csv) | The cleaned data produced at the end of `01_basics.R` |
| [`data/education_timeseries.csv`](data/education_timeseries.csv) | Monthly time series, Day 2 afternoon |

Scripts 02, 03 and 04 run on their own. Each one reads the file it needs from GitHub.

## Reading the data in your own script

```r
library(readr)
data_url <- "https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/data/"

students <- read_csv(paste0(data_url, "student_achievement.csv"))
edu      <- read_csv(paste0(data_url, "education_timeseries.csv"))
```

`read_excel()` cannot read a web address. Download the Excel file first:

```r
download.file(paste0(data_url, "student_achievement.xlsx"),
              "student_achievement.xlsx", mode = "wb")
students <- readxl::read_excel("student_achievement.xlsx")
```

No internet in the room? Use **Code → Download ZIP**, put the `data` files in your working
folder and replace `paste0(data_url, "...")` with the file name alone.

## The two datasets

**student_achievement.csv** — 300 students in six schools, 10 variables. Pretest and posttest
scores, three teaching methods (Traditional, Blended, Flipped), region, gender, weekly study
hours, attendance and motivation. The file contains deliberate problems for the cleaning
lesson: 6 missing values in `StudyHours`, 4 in `Motivation`, and 2 impossible `Attendance`
values (120 and 135 percent, rows S103 and S132).

**education_timeseries.csv** — 120 consecutive months, January 2015 to December 2024. Monthly
attendance rate and an enrolment index, with an upward trend, an annual seasonal pattern, a
disruption during 2020 and 3 missing values (rows 30, 64 and 95) for the interpolation lesson.

Every number printed on a slide comes from these exact files. A console that disagrees with
the slide points to a step worth checking.

## Licence and citation

The R scripts are released under the [MIT licence](LICENSE). The data files in `data/` are
synthetic teaching data released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
Both may be reused for teaching with attribution.

To cite these materials, use the **Cite this repository** button on this page
(generated from [`CITATION.cff`](CITATION.cff)).

![QR code for this repository](assets/qr_github.png)
