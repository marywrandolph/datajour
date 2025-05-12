# Load required packages
install.packages("httr", repos = "https://cloud.r-project.org")
install.packages("jsonlite", repos = "https://cloud.r-project.org")

library(httr)
library(jsonlite)
library(tidyverse)

# Define API URL
url <- "https://data.boston.gov/dataset/1e497a44-779b-4e28-a6dd-b7d56de61233/resource/f04a85cf-7d40-49c5-acdb-fdb1626cf911/download/treekeeper_street_trees.csv"

# Make GET request
response <- GET(url)

# Check response status
if (status_code(response) != 200) {
  stop("Failed to fetch data. Status code: ", status_code(response))
}

data <- content(response, as = "raw")
csv_text <- rawToChar(data)
csv_text <- sub("\ufeff", "", csv_text)  # remove BOM if present

parsed_data <- read_csv(csv_text)

# Create data directory if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data")
}

# Timestamped file name
filename <- paste0("data/trees_new.csv")

# Save CSV to file
write(data, file = filename)

cat("Saved data to", filename, "\n")
