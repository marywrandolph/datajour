library(janitor)
library(tidyverse)
library(lubridate)

#Creating df

rideshare23 <- read_csv("group_story/rideshare2324.csv") |> clean_names()
rideshare22 <- read_csv("group_story/rideshare1822.csv") |> clean_names() |>
  select(trip_start_timestamp, trip_end_timestamp, trip_seconds, trip_miles, pickup_census_tract, dropoff_census_tract, pickup_community_area, dropoff_community_area, trip_total, pickup_centroid_location, dropoff_centroid_location)

rideshare <- rbind(rideshare22, rideshare23) |> filter(trip_miles != 0, trip_seconds != 0)

write_csv(rideshare, "group_story/rideshare.csv")

#Location analyses

dropoff_pivot <- rideshare |>
  filter(pickup_census_tract == 17031808702) |>
  group_by(dropoff_centroid_location) |>
  count()

dropoff_pivot$dropoff_centroid_location <- str_remove(dropoff_pivot$dropoff_centroid_location, "POINT \\(")
dropoff_pivot$dropoff_centroid_location <- str_remove(dropoff_pivot$dropoff_centroid_location, "\\)")

dropoff_pivot <- separate(dropoff_pivot, dropoff_centroid_location, into = c("lon", "lat"), sep = " ")

write_csv(dropoff_pivot, "group_story/dropoff_pivot.csv")

pickup_pivot <- rideshare |>
  filter(dropoff_census_tract == 17031808702) |>
  group_by(pickup_centroid_location) |>
  count()

pickup_pivot$pickup_centroid_location <- str_remove(pickup_pivot$pickup_centroid_location, "POINT \\(")
pickup_pivot$pickup_centroid_location <- str_remove(pickup_pivot$pickup_centroid_location, "\\)")

pickup_pivot <- separate(pickup_pivot, pickup_centroid_location, into = c("lon", "lat"), sep = " ")

write_csv(pickup_pivot, "group_story/pickup_pivot.csv")

#Cost analyses

fare_breakdown <- rideshare %>%
  mutate(trip_bucket = cut(trip_total, 
                           breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 400))) |>
  group_by(trip_bucket) |>
  count()

fare_breakdown_to_chi <- rideshare %>%
  filter(pickup_census_tract == 17031808702) |>
  mutate(trip_bucket = cut(trip_total, 
                           breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 400))) |>
  group_by(trip_bucket) |>
  count()

fare_breakdown_to_etown <- rideshare %>%
  filter(dropoff_census_tract == 17031808702) |>
  mutate(trip_bucket = cut(trip_total, 
                           breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 400))) |>
  group_by(trip_bucket) |>
  count()

write_csv(fare_breakdown, "group_story/fare_breakdown.csv")
write_csv(fare_breakdown_to_chi, "group_story/fare_breakdown_to_chi.csv")
write_csv(fare_breakdown_to_etown, "group_story/fare_breakdown_to_etown.csv")

rideshare <- rideshare |>
  mutate(cost_per_second=trip_total/trip_seconds) |>
  mutate(cost_per_mile=trip_total/trip_miles) 

dropoff_area_cost_summary <- rideshare |>
  filter(pickup_census_tract == 17031808702) |>
  group_by(dropoff_community_area) |>
  summarize(
    avg_per_mile = mean(cost_per_mile, na.rm = TRUE),
    avg_per_second = mean(cost_per_second, na.rm = TRUE)
  )

pickup_area_cost_summary <- rideshare |>
  filter(dropoff_census_tract == 17031808702) |>
  group_by(pickup_community_area) |>
  summarize(
    avg_per_mile = mean(cost_per_mile, na.rm = TRUE),
    avg_per_second = mean(cost_per_second, na.rm = TRUE)
  )

write_csv(dropoff_area_cost_summary, "group_story/dropoff_area_cost_summary.csv")
write_csv(pickup_area_cost_summary, "group_story/pickup_area_cost_summary.csv")

#Ride time analyses

time_cost_summary <- rideshare |>
  mutate(start_time = format(mdy_hms(trip_start_timestamp), "%H:%M:%S")) |>
  group_by(start_time) |>
  summarize(
    avg_per_mile = mean(cost_per_mile, na.rm = TRUE),
    avg_per_second = mean(cost_per_second, na.rm = TRUE)
  )

trips_per_time <- rideshare |>
  mutate(start_time = format(mdy_hms(trip_start_timestamp), "%H:%M:%S")) |>
  group_by(start_time) |>
  count()

trips_per_time_to_chi <- rideshare |>
  filter(pickup_census_tract == 17031808702) |>
  mutate(start_time = format(mdy_hms(trip_start_timestamp), "%H:%M:%S")) |>
  group_by(start_time) |>
  count()

trips_per_time_to_etown <- rideshare |>
  filter(dropoff_census_tract == 17031808702) |>
  mutate(start_time = format(mdy_hms(trip_start_timestamp), "%H:%M:%S")) |>
  group_by(start_time) |>
  count()

write_csv(trips_per_time, "group_story/trips_per_time.csv")
write_csv(trips_per_time_to_chi, "group_story/trips_per_time_to_chi.csv")
write_csv(trips_per_time_to_etown, "group_story/trips_per_time_to_etown.csv")
write_csv(time_cost_summary, "group_story/time_cost_summary.csv")

length_pivot <- rideshare |>
  mutate(trip_minutes = trip_seconds/60) |>
  mutate(trip_minutes_rounded = round(trip_minutes)) |>
 group_by(trip_minutes_rounded) |>
  count()

write_csv(length_pivot, "group_story/trip_lengths.csv")  
