# Practical Data Analysis and Forecasting with R
### for Social and Educational Research — two-day workshop materials

Pattharaporn Thongnim - Department of Mathematics, Faculty of Science, Burapha University

Every script reads its data directly from this repository. Open a script in
RStudio and run it. There is nothing to download and no `setwd()` to set.

## Before the workshop: install R and RStudio

**No programming experience is needed.** Please do these steps at home before the first
day. They take about 20 minutes and need a good internet connection. If anything goes
wrong, stop and bring your laptop to the workshop. We will fix it together.

You need two programs, and the order matters.

- **R** is the program that does the calculations. Install it **first**.
- **RStudio** is the window you work in. Install it **second**. It cannot work without R.

### Step 1. Check your computer

- **Windows:** press the **Windows key**, type `winver` and press **Enter**. The window shows
  Windows 10 or Windows 11. The current RStudio needs **Windows 11**. Windows 10 users, see
  [Problems and solutions](#problems-and-solutions).
- **Mac:** click the **Apple menu** (top-left corner of the screen) → **About This Mac**. Write down two things.
  - **Chip:** "Apple M1, M2, M3 or M4" means *Apple silicon*. "Intel" means *Intel*.
  - **macOS version:** you need macOS 14 (Sonoma) or newer for the current RStudio.
    If your Mac is older, see [Problems and solutions](#problems-and-solutions).

### Step 2. Install R

1. Open <https://cran.r-project.org>. Download R only from this official site.
2. Choose your system.

| Your computer | Click | Then download |
|---|---|---|
| Windows | **Download R for Windows** → **base** | **Download R-4.x.x for Windows** (a file ending in `.exe`) |
| Mac with Apple silicon | **Download R for macOS** | the file ending in **`-arm64.pkg`** |
| Mac with Intel | **Download R for macOS** | the file ending in **`-x86_64.pkg`** |

3. Open the file you downloaded.
   - **Windows:** click **Yes** if Windows asks for permission. Then click **Next** on every
     screen and **Finish** at the end. Do not change any setting.
   - **Mac:** click **Continue** on every screen, then **Agree**, then **Install**. Type your
     Mac password when asked. Click **Close** at the end.

### Step 3. Install RStudio

1. Open <https://posit.co/download/rstudio-desktop>.
2. The page opens at a table called **Direct Downloads (Open Source)**, under the heading
   **RStudio IDE**. Click the file name in the row for your computer.
   - **Windows 11:** the file ending in **`.exe`**
   - **Mac (macOS 14 or newer):** the file ending in **`.dmg`**
3. Open the file you downloaded.
   - **Windows:** click **Yes**, then **Next** on every screen, then **Finish**.
   - **Mac:** a window opens with the RStudio icon and an **Applications** folder.
     **Drag the RStudio icon onto the Applications folder.** Wait until copying finishes.
     Then eject the "RStudio" disk in Finder.
4. Open RStudio.
   - **Windows:** Start menu → **RStudio**.
   - **Mac:** Finder → **Applications** → **RStudio**. The first time, macOS asks
     *"RStudio is an app downloaded from the Internet. Are you sure you want to open it?"*
     Click **Open**.

### Step 4. Check that R works

RStudio has four panels. Find the **Console** (usually bottom left). The first line should
read **R version 4.x.x**. That means RStudio has found R.

Click inside the Console, type the line below and press **Enter**.

```r
R.version.string
```

R should answer with its version number. If it does, R and RStudio are installed.

### Step 5. Install the workshop packages

Copy the line below. Click inside the Console, paste it (**Ctrl + V** on Windows,
**Cmd + V** on Mac) and press **Enter**.

```r
source("https://raw.githubusercontent.com/Pattharaporn-Aon/R-workshop-2026/main/R/00_setup.R")
```

This takes **3 to 5 minutes**. A lot of red text will scroll past. **Red text is normal here.
It is not an error.** Wait until the Console shows the `>` sign again.

You are ready when the last two lines say:

```
All packages loaded. You are ready.
Data loaded from GitHub. You are ready.
```

### Problems and solutions

| What you see | What to do |
|---|---|
| RStudio opens but says it cannot find R | R is not installed, or was installed after RStudio. Install R (Step 2), then close and reopen RStudio. |
| A Mac says the app "cannot be opened" | Finder → Applications → right-click **RStudio** → **Open** → **Open**. |
| On a Mac, RStudio disappears after a restart | RStudio was opened from the download window instead of Applications. Repeat Step 3 and drag it onto **Applications**. |
| Your Mac is older than macOS 14, or you use Windows 10 | R still installs normally (Step 2). The current RStudio does not. Use RStudio in your web browser instead (see the row about [posit.cloud](https://posit.cloud) below), or bring the laptop and we will install an older RStudio together. |
| **Windows:** packages fail to install and the error shows a folder path with Russian or Kazakh letters | Your Windows user name is not in Latin letters. Paste the two lines below into the Console, press Enter, then close and reopen RStudio. Then repeat Step 5. |
| You cannot install programs on this computer (for example, a work laptop) | Use RStudio in your web browser instead. Create a free account at <https://posit.cloud>, click **New Project → New RStudio Project**, and do Step 5 there. |
| Something else | Take a screenshot of the Console and send it to the instructor before the workshop. |

Fix for a Windows user name in Russian or Kazakh letters:

```r
dir.create("C:/Rlib")
cat('R_LIBS_USER="C:/Rlib"\n', file = file.path(Sys.getenv("R_USER"), ".Renviron"))
```

## Quick start

1. Install R and RStudio. Follow [Before the workshop](#before-the-workshop-install-r-and-rstudio) above.
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
