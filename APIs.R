library(tidyverse)

library(httr)

# Download the file
url <- "https://data.cityofchicago.org/resource/twrw-chuq.csv"
response <- GET(url)

# Save it locally
writeBin(content(response, "raw"), "data/profile_2025.csv")

profile_2025 <- read_csv("data/profile_2025.csv")

url2 <- "https://data.cityofchicago.org/resource/dw27-rash.csv"
response2 <- GET(url2)

# Save it locally
writeBin(content(response2, "raw"), "data/profile_2019.csv")

profile_2019 <- read_csv("data/profile_2019.csv")

truancy_25 <- profile_2025 |>
  select(short_name, primary_category, chronic_truancy_pct)

truancy_19 <- profile_2019 |>
  select(short_name, primary_category, chronic_truancy_pct)

truancy_compare <- truancy_19 |>
  inner_join(truancy_25, join_by(short_name, primary_category)) |>
  rename("truancy_pct_2019" = chronic_truancy_pct.x) |>
  rename("truancy_pct_2025" = chronic_truancy_pct.y)
  
