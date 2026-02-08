- NOTE 
# This script is designed to be run in a local environment where, the working directory is set 
to the project folder containing all the documents for this project. 

#setting working directory
setwd("/Users/barbiejindal/Desktop/EV_Adoption_Project")
list.files()
getwd () 
dir.create("outputs", showWarnings = FALSE)

#load libraries
library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# Read CSVs directly from current folder
ev_by_year <- read_csv("ev_by_year.csv")
ev_by_year_type <- read_csv("ev_by_year_type.csv")
top_counties <- read_csv("top_counties.csv")
top_cities <- read_csv("top_cities.csv")
make_share <- read_csv("make_share.csv")
range_by_group <- read_csv("range_by_adoption_group.csv")

# Q1, PART 1: EV adoption trend over time
p1 <- ggplot(ev_by_year, aes(model_year, ev_count)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = comma) +
  labs(
    title = "EV Adoption Over Time",
    x = "Model Year",
    y = "Registered EV Count"
  )

ggsave("outputs/ev_adoption_over_time.png", p1, width = 9, height = 5)

# Q1, PART 2: BEV vs PHEV adoption trends
p2 <- ggplot(ev_by_year_type, aes(model_year, ev_count, color = ev_type)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = comma) +
  labs(
    title = "BEV vs PHEV Adoption Over Time",
    x = "Model Year",
    y = "Registered EV Count",
    color = "EV Type"
  )

ggsave("outputs/bev_vs_phev.png", p2, width = 9, height = 5)

# Q2, PART 1: Top counties by EV adoption
top10_counties <- top_counties %>%
  slice_max(ev_count, n = 10) %>%
  arrange(ev_count)

p3 <- ggplot(top10_counties, aes(ev_count, county)) +
  geom_col() +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Top 10 Counties by EV Adoption",
    x = "EV Count",
    y = "County"
  )

ggsave("outputs/top_counties.png", p3, width = 9, height = 5)

# Q2, PART 2: Top cities by EV adoption
top10_cities <- top_cities %>%
  slice_max(ev_count, n = 10) %>%
  arrange(ev_count)

p4 <- ggplot(top10_cities, aes(ev_count, paste(city, county, sep = ", "))) +
  geom_col() +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Top 10 Cities by EV Adoption",
    x = "EV Count",
    y = "City"
  )

ggsave("outputs/top_cities.png", p4, width = 10, height = 6)

# Q3, PART 1: Manufacturer market share
top_make <- make_share %>%
  slice_max(share_pct, n = 10) %>%
  arrange(share_pct)

p5 <- ggplot(top_make, aes(share_pct, make)) +
  geom_col() +
  labs(
    title = "Top EV Manufacturers by Market Share",
    x = "Market Share (%)",
    y = "Manufacturer"
  )

ggsave("outputs/manufacturer_share.png", p5, width = 9, height = 5)

# Q4, PART 2: Electric range by adoption group
p6 <- ggplot(range_by_group, aes(adoption_group, avg_range)) +
  geom_col() +
  labs(
    title = "Average Electric Range by Adoption Group",
    x = "Adoption Group",
    y = "Average Electric Range"
  )

ggsave("outputs/range_by_adoption_group.png", p6, width = 8, height = 5)

list.files("outputs")

