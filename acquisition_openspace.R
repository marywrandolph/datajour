library(curl)
library(tidyverse)


# Define API URL
url <- "https://data.boston.gov/dataset/66a3324e-066f-4caf-897b-a2b4dcb8bc42/resource/61c0239f-c8fd-47de-8375-2405382ef37c/download/open_space.csv"

# Create a connection to the API using curl
con <- curl(url, open = "r")

# Create a connection to the API using curl and fetch raw data
h <- new_handle()
con <- curl(url, handle = h)

# Read the content into raw data
raw_data <- readLines(con)

# Close the connection
close(con)

# Convert raw data to a character vector (clean up the data if needed)
csv_text <- paste(raw_data, collapse = "\n")

# Parse the CSV content into a data frame
open_space_data <- read_csv(csv_text)

url <- "https://data.boston.gov/dataset/bf1a7b50-4c72-4637-b0fa-11d632e3aff1/resource/d45a6d03-2616-4449-9687-0c864ec9f9e4/download/boston_neighborhood_boundaries.csv"
# Create a connection to the API using curl
con <- curl(url, open = "r")

# Create a connection to the API using curl and fetch raw data
h <- new_handle()
con <- curl(url, handle = h)

# Read the content into raw data
raw_data <- readLines(con)

# Close the connection
close(con)

# Convert raw data to a character vector (clean up the data if needed)
csv_text <- paste(raw_data, collapse = "\n")

# Parse the CSV content into a data frame
neighborhood_data <- read_csv(csv_text) |>
  select(name, acres) |>
  rbind(data.frame(name = "Allston-Brighton", acres = 2838.94308))|>
  rbind(data.frame(name = "Back Bay/Beacon Hill", acres = 599.47131)) |>
  rbind(data.frame(name = "Fenway/Longwood", acres = 788.08326))


open_space_data_neighborhoods <- open_space_data |>
  filter(TypeLong != "Cemeteries & Burying Grounds" & TypeLong != "Malls, Squares & Plazas") |>
  group_by(DISTRICT) |>
  summarize(total_space = sum(ACRES, na.rm =TRUE)) |>
  full_join(neighborhood_data, by = c("DISTRICT" = "name"))

# Save as timestamped CSV
filename <- paste0("data/open_space_data.csv")

write_csv(open_space_data, filename)
