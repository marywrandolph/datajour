library(tidyverse)

profile_2019 = read.csv("data/profile_2019.csv")
profile_2025 = read.csv("data/profile_2025.csv")

truancy_25 <- profile_2025 |>
  select(Short_Name, Primary_Category, Chronic_Truancy_Pct)

truancy_19 <- profile_2019 |>
  select(Short_Name, Primary_Category, Chronic_Truancy_Pct)

truancy_compare <- truancy_19 |>
  inner_join(truancy_25, join_by(Short_Name, Primary_Category)) |>
  rename("truancy_pct_2019" = Chronic_Truancy_Pct.x) |>
  rename("truancy_pct_2025" = Chronic_Truancy_Pct.y)
  
