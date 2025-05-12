# Load required packages
install.packages("httr", repos = "https://cloud.r-project.org")
install.packages("jsonlite", repos = "https://cloud.r-project.org")

library(httr)
library(jsonlite)
library(tidyverse)


# Define API URL
url <- "https://data.boston.gov/dataset/66a3324e-066f-4caf-897b-a2b4dcb8bc42/resource/61c0239f-c8fd-47de-8375-2405382ef37c/download/open_space.csv"
# Make GET request
response <- GET(url)

# Check response status
if (status_code(response) != 200) {
  stop("Failed to fetch data. Status code: ", status_code(response))
}

data <- content(response, as = "raw")
csv_text <- rawToChar(data)
csv_text <- sub("\ufeff", "", csv_text)  # remove BOM if present

parsed_data_space <- read_csv(csv_text)

# Create data directory if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data")
}

# Timestamped file name
filename <- paste0("data/open_space.csv")

# Save CSV to file
write(data, file = filename)
