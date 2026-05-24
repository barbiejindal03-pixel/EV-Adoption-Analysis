# EV Adoption Analysis
**Author:** Barbie Jindal | [LinkedIn](https://linkedin.com/in/barbiejindal) | [Portfolio](https://barbiejindal.com)

Multi-tool descriptive analysis of US electric vehicle adoption trends (1999–2026) using SAS, BigQuery, Python, and R — mapping state, county, and city-level registration patterns, manufacturer market share, and vehicle characteristics across high and low adoption regions.

---

## Business Questions Answered

| # | Question |
|---|---|
| Q1 | How has EV adoption grown over time? (BEV vs PHEV breakdown) |
| Q2 | Which counties and cities lead EV adoption? |
| Q3 | Which manufacturers dominate the EV market, and how does this vary by region? |
| Q4 | Do high-adoption regions have higher electric range vehicles? What is the EV type and CAFV eligibility mix? |

---

## Tech Stack

| Tool | Purpose |
|---|---|
| **SAS Studio** | Data import, cleaning, and initial SQL-based aggregations |
| **Google BigQuery** | Cloud SQL — running advanced queries on the full dataset at scale |
| **Python** (pandas, matplotlib, google-cloud-bigquery) | BigQuery pipeline, data transformation, and chart generation |
| **R** (ggplot2, dplyr) | Statistical visualization and exploratory data analysis |
| **Git** | Version control |

---

## Key Findings

- **Tesla dominates** with 40.77% market share — nearly 6x the next competitor (Chevrolet at 7.02%)
- **King County (Seattle area)** accounts for 133,815 registered EVs — more than 4x the next county (Snohomish at 33,766)
- **High-adoption counties** show a significantly higher share of long-range BEVs vs low-adoption counties, which skew toward PHEVs
- EV registrations grew exponentially from 1999, with the steepest growth post-2018

---

## Project Structure

```
EV_Adoption_Project/
│
├── ev_adoption_analysis.sas        # SAS: data import, cleaning, SQL aggregations
├── ev_adoption_bigquery.sql        # BigQuery SQL: all queries translated to cloud
├── ev_bigquery_pipeline.py         # Python: BigQuery pipeline + chart generation
├── r coding_ev_adoption_analysis.r # R: ggplot2 visualizations
│
├── make_share.csv                  # Manufacturer market share output
├── top_counties.csv                # Top counties by EV count output
│
└── outputs/                        # Generated charts
    ├── ev_adoption_over_time.png
    ├── bev_vs_phev.png
    ├── top_counties.png
    ├── top_cities.png
    ├── manufacturer_share.png
    └── range_by_adoption_group.png
```

---

## How to Run

### BigQuery Pipeline (Python)
```bash
# Install dependencies
pip install google-cloud-bigquery pandas matplotlib db-dtypes

# Set up Google Cloud (one-time)
# 1. Go to console.cloud.google.com
# 2. Create a project and enable BigQuery API
# 3. Create dataset 'ev_project' and upload the CSV as table 'ev_population'
# 4. Download your service account key JSON

# Run the pipeline
python ev_bigquery_pipeline.py
```

### SAS
Open `ev_adoption_analysis.sas` in SAS Studio and run all sections.

### R Visualizations
```r
# Install required packages
install.packages(c("readr", "dplyr", "ggplot2", "scales"))

# Run the script
source("r coding_ev_adoption_analysis.r")
```

---

## Data Source
[Electric Vehicle Population Data](https://catalog.data.gov/dataset/electric-vehicle-population-data) — Washington State Department of Licensing via data.gov
