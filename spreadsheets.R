library(tidyverse)

boston_crashes <- read.csv("data/boston_crashes.csv")

dashboard_deadzones <- boston_crashes |> 
  filter(mode_type == "mv") |> 
  mutate(
    deadzone_area = case_when(
      lat > 42.362 & lat < 42.368 & long > -71.165 & long < -71.158 ~ "Upper Left",
      lat > 42.360 & lat < 42.365 & long > -71.150 & long < -71.143 ~ "Middle Left",
      lat > 42.341 & lat < 42.347 & long > -71.104 & long < -71.098 ~ "Fenway",
      lat > 42.359 & lat < 42.363 & long > -71.078 & long < -71.072 ~ "Esplanade",
      TRUE ~ NA_character_
    )
  ) |> 
  filter(!is.na(deadzone_area))

dashboard_deadzones |> 
  count(deadzone_area)

boston_crashes |>
  count(street) |>
  arrange(desc(n))


crash_density <- boston_crashes |> 
  mutate(
    lat_bin = cut(lat, breaks = seq(42.3, 42.4, by = 0.005)),
    long_bin = cut(long, breaks = seq(-71.2, -71.05, by = 0.005))
  ) |> 
  count(lat_bin, long_bin) |> 
  arrange(desc(n)) |>
  filter(!is.na(lat_bin)) |>
  filter(!is.na(long_bin))

boston_crashes |>
  filter(lat > 42.362 & lat < 42.368 & long > -71.165 & long < -71.158)
