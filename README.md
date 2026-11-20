# HIV/TB Loss to Follow-Up (LTFU) Analysis

## 📌 Project Overview
This repository contains the R code for cleaning, descriptive analysis, and multivariable logistic regression on two datasets (Data A and Data B) evaluating predictors of Loss to Follow-Up (LTFU) in an HIV/TB cohort.

## 🛠️ Skills Demonstrated
- **Data Wrangling:** Cleaning messy clinical data, parsing text-based dates, handling missing values, and harmonizing categorical variables using `dplyr` and `stringr`.
- **Statistical Modeling:** Univariable screening followed by multivariable logistic regression models to identify independent predictors of LTFU (using `glm` and `broom`).
- **Model Evaluation:** Assessing discrimination via ROC/AUC curves and calibration using the Hosmer-Lemeshow test.
- **Reporting:** Reproducible research using R Markdown to combine code, visualizations, and clinical interpretation.

## 📁 Files
- [Data_A_clean.R](Data_A_clean.R): The cleaning script for Data A.
- [Data_B_clean.R](Data_B_clean.R): The cleaning script for Data B.
- [Data_A_report.Rmd](Data_A_report.Rmd) & [Data_B_report.Rmd](Data_B_report.Rmd): The R Markdown source codes.
- [👉 Click here to view the live Data A HTML report!](https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/Data_A_report.html)
- [👉 Click here to view the live Data B HTML report!](https://YOUR-USERNAME.github.io/YOUR-REPO-NAME/Data_B_report.html)

## 🔒 Data Availability
Due to patient confidentiality and data privacy regulations, the raw `.xlsx` files and cleaned `.rds` files are **not** included in this repository.
