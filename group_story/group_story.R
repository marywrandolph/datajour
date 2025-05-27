library(janitor)
library(tidyverse)

read_csv("group_story/rideshare.csv")
dropoffs <- read_csv("group_story/dropoffs.csv") |>
  clean_names()

dropoffs$dropoff_centroid_location <- str_remove(dropoffs$dropoff_centroid_location, "POINT \\(")
dropoffs$dropoff_centroid_location <- str_remove(dropoffs$dropoff_centroid_location, "\\)")

write_csv(dropoffs, "group_story/dropoffs.csv")
