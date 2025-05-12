library(tidyverse)

boston_crashes <- read.csv("data/boston_crashes.csv")
chicago_crashes <- read.csv("data/chicago_traffic.csv")

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

write_csv(dashboard_deadzones, file = "analyses/spreadsheet_lab/dashboard_deadzones.csv")

deadzone_crash_density <- dashboard_deadzones |> 
  count(deadzone_area)

write_csv(deadzone_crash_density, file = "analyses/spreadsheet_lab/deadzone_crash_density.csv")

boston_crashes |>
  count(street) |>
  arrange(desc(n))


crash_density <- chicago_crashes |> 
  mutate(
    lat_bin = cut(Latitude, breaks = seq(41.6, 42.1, by = 0.005)),
    long_bin = cut(Longitude, breaks = seq(-87.95, -87.5, by = 0.005))
  ) |>
  filter(!is.na(lat_bin), !is.na(long_bin)) |>
  count(lat_bin, long_bin) |> 
  mutate(
    lat_center = as.numeric(sub("\\((.+),(.+)\\]", "\\1", lat_bin)) + 0.0025,
    long_center = as.numeric(sub("\\((.+),(.+)\\]", "\\1", long_bin)) + 0.0025
  ) |>
  arrange(desc(n))


write_csv(crash_density, file = "analyses/spreadsheet_lab/crash_density.csv")

boston_crashes |>
  filter(lat > 42.362 & lat < 42.368 & long > -71.165 & long < -71.158)

library(tidyverse)
library(tidygeocoder)

# Read your CSV file
data <- read_csv("data/FOIA_Kiefer Smart Streets data 20250408 - Sheet 1.csv")

# Check column names to find the address column
print(names(data))

# Let's assume your address column is named "address"
# Replace "address" below with the correct column name if different

# Geocode addresses
data_geocoded <- data %>%
  geocode(address = Location, method = "osm", lat = latitude, long = longitude)

# Check the results
head(data_geocoded)

# Save the new dataset
write_csv(data_geocoded, "FOIA_Kiefer_Smart_Streets_with_Geocodes.csv")

library(VFS)
weather <- read.dly(system.file("extdata", "data/USW00014892.dly", package = "VFS"))


