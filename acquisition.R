
library(curl)
library(tidyverse)

# Define API URL
url <- "https://data.boston.gov/dataset/1e497a44-779b-4e28-a6dd-b7d56de61233/resource/f04a85cf-7d40-49c5-acdb-fdb1626cf911/download/treekeeper_street_trees.csv"

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
tree_data <- read_csv(csv_text)

# Save as timestamped CSV
filename <- paste0("data/tree_data.csv")

write_csv(tree_data, filename)

cat("Data saved to", filename, "\n")
