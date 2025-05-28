library(janitor)
library(tidyverse)

rideshare <- read_csv("group_story/rideshare.csv") |> clean_names()

dropoff_pivot <- read_csv("group_story/rideshare.csv") |>
  group_by(dropoff_centroid_location) |>
  count()

dropoff_pivot$dropoff_centroid_location <- str_remove(dropoff_pivot$dropoff_centroid_location, "POINT \\(")
dropoff_pivot$dropoff_centroid_location <- str_remove(dropoff_pivot$dropoff_centroid_location, "\\)")

dropoff_pivot <- separate(dropoff_pivot, dropoff_centroid_location, into = c("lon", "lat"), sep = " ")

write_csv(dropoff_pivot, "group_story/dropoff_pivot.csv")

fare_breakdown <- rideshare %>%
  mutate(trip_bucket = cut(trip_total, breaks = 20)) |>
  group_by(trip_bucket) |>
  count()

rideshare <- rideshare |>
  mutate(cost_per_second=trip_total/trip_seconds) |>
  mutate(cost_per_mile=trip_total/trip_miles) 

inflation_summary <- rideshare |> 
  mutate(year = year(trip_start_timestamp_1)) |>
  group_by(year) |>
  summarize(
    avg_per_mile = mean(cost_per_mile, na.rm = TRUE),
    avg_per_second = mean(cost_per_second, na.rm = TRUE)
  )

area_cost_summary <- rideshare |>
  group_by(dropoff_community_area) |>
  summarize(
    avg_per_mile = mean(cost_per_mile, na.rm = TRUE),
    avg_per_second = mean(cost_per_second, na.rm = TRUE)
  )

write_csv()