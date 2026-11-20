# HIV/TB Loss to Follow-Up (LTFU) Analysis

This repository contains the R code for cleaning, descriptive analysis, and multivariable logistic regression on two datasets (Data A and Data B) evaluating predictors of Loss to Follow-Up (LTFU) in an HIV/TB cohort.

## 📂 Project Structure

- `Data_A_clean.R` and `Data_B_clean.R`: Scripts to clean the raw Excel data, handle date parsing, and harmonize categorical variables.
- `Data_A_report.Rmd` / `Data_B_report.Rmd`: R Markdown files generating the descriptive statistics and regression models.
- `Data_A_report.html` / `Data_B_report.html`: Fully rendered, viewable reports.

## 🔒 Data Availability

Due to patient confidentiality and data privacy regulations, the raw `.xlsx` files and cleaned `.rds` files are **not** included in this repository.

## 🚀 How to Reproduce

1.  Clone this repository.
2.  Place the raw `Data_A.xlsx` and `Data_B.xlsx` files in the root directory.
3.  Run `Data_A_clean.R` and `Data_B_clean.R` to generate the cleaned datasets.
4.  Knit the `.Rmd` files to generate the HTML reports.

## 📊 Key Findings

- **Data A:** Alcohol consumption was independently associated with a 3.16-fold increase in the odds of LTFU (p = 0.002).
- **Data B:** Educational level was the primary independent predictor; tertiary education reduced the odds of LTFU by 89% (OR = 0.11, p = 0.019).
