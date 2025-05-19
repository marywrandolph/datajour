library(tidyverse)
library(janitor)

tree_data <- read_csv("data/tree_data.csv")

tree_data$neighborhood[tree_data$neighborhood == "Central Boston"] <- "Downtown"


neighborhood_data <- read_csv("data/neighborhood_data.csv")
populations <- read_csv("data/neighborhood_pops.csv") |> clean_names

tree_data_neighborhoods <- tree_data |>
  group_by(neighborhood) |>
  summarize(total_space = sum(numberof_st, na.rm =TRUE)) |>
  left_join(neighborhood_data, by = c("neighborhood" = "name")) |>
  mutate(trees_per_100_acres = (total_space/acres)*100) |>
  left_join(populations, by = c("neighborhood" = "x1")) |>
  mutate(trees_per_100_people = (total_space/total_population)*100)
