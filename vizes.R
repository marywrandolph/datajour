install.packages("duckdb")
library("duckdb")
library("dplyr")
library(janitor)

con <- dbConnect(duckdb())

chicago_weather <- read.csv("data/chicago_weather.csv") |>
  clean_names() 

chicago_weather <- chicago_weather |> mutate(date = as.Date(measurement_timestamp_1, format = "%Y-%m-%d"))

daily_avg_temp <- chicago_weather |> 
  mutate(date = as.Date(date)) |> 
  group_by(date) |> 
  summarise(avg_temperature = mean(air_temperature, na.rm = TRUE)) |> 
  filter(year(date) %in% c(2020, 2021, 2022, 2023, 2024, 2025)) |> 
  mutate(year = year(date))
  arrange(date)

write.csv(daily_avg_temp, "analyses/daily_avg_temp.csv")

religion24 <- read.csv("data/24religion.csv")

religion15 <- read