# 01_clean.R — cleans Data_A.xlsx and saves Data_A_clean.rds

library(readxl); library(dplyr); library(stringr)
library(lubridate); library(janitor); library(readr)

# --- Load ---
Data_A <- read_excel("Data A.xlsx") %>% clean_names()

# --- NA codes ---
na_variants <- c("no record", "n/a", "n.a", "m/a", "n/n", "na")
Data_A <- Data_A %>%
  mutate(across(where(is.character), ~str_trim(tolower(.x)))) %>%
  mutate(across(where(is.character),
                ~if_else(. %in% na_variants, NA_character_, .)))

# --- Numeric-from-text ---
word_to_num <- function(x) case_when(
  str_detect(x, "\\bone\\b")   ~ 1, str_detect(x, "\\btwo\\b")   ~ 2,
  str_detect(x, "\\bthree\\b") ~ 3, str_detect(x, "\\bfour\\b")  ~ 4,
  str_detect(x, "\\bfive\\b")  ~ 5, str_detect(x, "\\bsix\\b")   ~ 6,
  str_detect(x, "\\bseven\\b") ~ 7, str_detect(x, "\\beight\\b") ~ 8,
  TRUE ~ NA_real_)

Data_A <- Data_A %>%
  mutate(
    age_num             = suppressWarnings(parse_number(age)),
    hh_members_num      = coalesce(suppressWarnings(parse_number(no_of_h_h_members)),
                                   word_to_num(no_of_h_h_members)),
    sexual_partners_num = coalesce(suppressWarnings(parse_number(no_of_sexual_partners)),
                                   word_to_num(no_of_sexual_partners)),
    children_num        = case_when(
      children_ever_born %in% c("nil","none") ~ 0,
      TRUE ~ coalesce(suppressWarnings(parse_number(children_ever_born)),
                      word_to_num(children_ever_born))),
    time_on_tb_tx_num   = case_when(
      str_detect(period_on_tb_treatment, "never") ~ 0,
      TRUE ~ suppressWarnings(parse_number(period_on_tb_treatment))),
    ltfu_period_num     = case_when(
      str_detect(period_ltfu_for, "never") ~ 0,
      TRUE ~ suppressWarnings(parse_number(period_ltfu_for))),
    vl_initiation_num   = suppressWarnings(parse_number(viral_load_level_on_initiation)),
    cd4_initiation_num  = suppressWarnings(parse_number(cd4_vount_level)),
    vl_reincorp_num     = suppressWarnings(parse_number(viral_load_on_reincoportation)),
    cd4_reincorp_num    = suppressWarnings(parse_number(cd4_on_reincorporation)))

# --- Date serials -> NA ---
Data_A <- Data_A %>%
  mutate(
    time_on_tb_tx_num = if_else(time_on_tb_tx_num > 1000, NA_real_, time_on_tb_tx_num),
    ltfu_period_num   = if_else(ltfu_period_num   > 1000, NA_real_, ltfu_period_num))

# --- ART start dates -> year ---
parse_since <- function(x) {
  x <- str_trim(tolower(x))
  is_serial <- str_detect(x, "^\\d{4,}$")
  y <- str_remove(x, "^sin[ce]e?\\s*")
  y <- str_replace_all(y, "\\.", "")
  y <- str_replace(y, "([a-z])(\\d)", "\\1 \\2")
  y <- str_replace_all(y, "\\bune\\b",   "jun")
  y <- str_replace_all(y, "\\bjunly\\b", "jul")
  y <- str_replace_all(y, "\\bjulu\\b",  "jul")
  y <- str_replace_all(y, "\\bsug\\b",   "aug")
  y <- str_replace_all(y, "\\bay\\b",    "may")
  y <- str_replace(y, "sept", "sep")
  d <- suppressWarnings(dmy(y))
  d[is_serial] <- as.Date(as.numeric(x[is_serial]), origin = "1899-12-30")
  d
}

Data_A <- Data_A %>%
  mutate(
    art_start_date = case_when(
      str_detect(tolower(length_of_time_on_art), "never") ~ as.Date(NA),
      TRUE ~ parse_since(length_of_time_on_art)),
    art_start_year = year(art_start_date))

# --- Categorical recodes ---
yn <- function(x) case_when(
  str_detect(x, "^y|yees") ~ "yes",
  str_detect(x, "^no?\\b|^n\\.?$|^not") ~ "no",
  TRUE ~ NA_character_)

Data_A <- Data_A %>%
  mutate(
    alcohol_clean       = yn(alcohol_consumption),
    smoking_clean       = yn(smoking_habit),
    sport_clean         = yn(participation_in_sport),
    tm_use_clean        = yn(traditional_medicine_use),
    side_effects_clean  = yn(side_effects_from_pills),
    ever_ltfu_clean     = yn(ever_ltfu),
    acuteness_clean     = yn(acuteness_since_ltfu),
    other_disease_clean = yn(any_other_disease_or_condition),
    condom_clean = case_when(
      str_detect(use_of_condoms, "inconsist") ~ "inconsistent",
      str_detect(use_of_condoms, "^y")        ~ "yes",
      str_detect(use_of_condoms, "^no")       ~ "no",
      TRUE ~ NA_character_),
    education_clean = case_when(
      str_detect(educational_level, "primary")   ~ "primary",
      str_detect(educational_level, "secondary") ~ "secondary",
      str_detect(educational_level, "tertiary")  ~ "tertiary",
      TRUE ~ NA_character_),
    disease_clean = case_when(
      str_detect(diseases_status, "&|both")       ~ "HIV & TB",
      str_detect(diseases_status, "^hi|^hv|^hiv") ~ "HIV",
      str_detect(diseases_status, "^tb")          ~ "TB",
      TRUE ~ NA_character_),
    regimen_clean = case_when(
      str_detect(type_of_regimen, "both|&")       ~ "ART & TB",
      str_detect(type_of_regimen, "tpt")          ~ "ART & TPT",
      str_detect(type_of_regimen, "^art|^arrt")   ~ "ART",
      str_detect(type_of_regimen, "^tb|tretment") ~ "TB",
      TRUE ~ NA_character_),
    transport_clean = case_when(
      str_detect(mode_of_transport_used, "bi.?ycle")   ~ "bicycle",
      str_detect(mode_of_transport_used, "walk")       ~ "walking",
      str_detect(mode_of_transport_used, "taxi")       ~ "taxi",
      str_detect(mode_of_transport_used, "own car")    ~ "own car",
      str_detect(mode_of_transport_used, "family car") ~ "family car",
      TRUE ~ NA_character_),
    marital_clean = case_when(
      maritus_status %in% c("ma","married") ~ "married",
      maritus_status %in% c("cohabiting","single","widow") ~ maritus_status,
      TRUE ~ NA_character_))

# --- Drop constant ---
Data_A <- Data_A %>% select(-residential_area)

# --- Save ---
saveRDS(Data_A, "Data_A_clean.rds")
message("Cleaning complete. Saved Data_A_clean.rds (", nrow(Data_A), " rows).")


file.exists("Data_A_clean.rds")   # TRUE
Data_A <- readRDS("Data_A_clean.rds")
dim(Data_A)                       # 199 rows, ~56 columns


#Now trying to generate a logistic regression

library(dplyr); library(tidyr); library(stringr)
library(broom); library(car)

Data_A <- readRDS("Data_A_clean.rds")


Data_A %>% count(ever_ltfu, ever_ltfu_clean, useNA = "ifany")








#Step 2-4
Data_A <- Data_A %>%
  mutate(ltfu = case_when(
    ever_ltfu_clean == "yes" ~ 1,
    ever_ltfu_clean == "no"  ~ 0,
    TRUE ~ NA_real_))

table(Data_A$ltfu, useNA = "ifany")     # expect 0:106, 1:93

events  <- sum(Data_A$ltfu == 1, na.rm = TRUE)
epv_max <- floor(events / 10)
cat("Events:", events, " Max predictors:", epv_max, "\n")   # 93, 9


#Sanity check the candidate columns exist
candidates <- c("age_num", "gender", "education_clean", "employment_status",
                "marital_clean", "alcohol_clean", "smoking_clean",
                "disease_clean", "regimen_clean",
                "distance_from_health_facility", "transport_clean",
                "hh_members_num", "art_start_year", "side_effects_clean")

missing <- setdiff(candidates, names(Data_A))
missing    # should be character(0)

# How many complete cases per candidate? (missingness kills n)
sapply(Data_A[candidates], function(x) sum(!is.na(x)))



#Collapse sparse factor levels
