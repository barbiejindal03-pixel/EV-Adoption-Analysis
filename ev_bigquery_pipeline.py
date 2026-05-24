"""
EV Adoption Analysis — BigQuery Pipeline
Author: Barbie Jindal
Description: Connects to Google BigQuery, runs EV adoption queries,
             exports results to CSV, and generates visualizations.

SETUP INSTRUCTIONS:
1. pip install google-cloud-bigquery pandas matplotlib db-dtypes
2. Create a Google Cloud project at console.cloud.google.com
3. Enable the BigQuery API
4. Create a dataset called 'ev_project'
5. Upload Electric_Vehicle_Population_Data.csv as table 'ev_population'
6. Download your service account key JSON and set path below
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
from google.cloud import bigquery

# ── CONFIG ────────────────────────────────────────────────────────────────────
SERVICE_ACCOUNT_KEY = "your-service-account-key.json"   # <-- update this path
PROJECT_ID          = "your-gcp-project-id"             # <-- update this
DATASET_ID          = "ev_project"
TABLE_ID            = "ev_population"
OUTPUT_DIR          = "outputs"
# ──────────────────────────────────────────────────────────────────────────────

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = SERVICE_ACCOUNT_KEY
os.makedirs(OUTPUT_DIR, exist_ok=True)

client = bigquery.Client(project=PROJECT_ID)
TABLE  = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"


def run_query(sql: str) -> pd.DataFrame:
    """Run a BigQuery SQL query and return results as a DataFrame."""
    print(f"Running query...")
    return client.query(sql).to_dataframe()


# ── Q1 PART 1: EV adoption trend over time ───────────────────────────────────
print("\n[Q1.1] EV adoption by model year")
ev_by_year = run_query(f"""
    SELECT Model_Year AS model_year, COUNT(*) AS ev_count
    FROM `{TABLE}`
    GROUP BY model_year
    ORDER BY model_year
""")
ev_by_year.to_csv(f"{OUTPUT_DIR}/ev_by_year.csv", index=False)

fig, ax = plt.subplots(figsize=(10, 5))
ax.plot(ev_by_year["model_year"], ev_by_year["ev_count"], marker="o", color="#1f77b4")
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{int(x):,}"))
ax.set_title("EV Adoption Over Time", fontsize=14, fontweight="bold")
ax.set_xlabel("Model Year")
ax.set_ylabel("Registered EV Count")
ax.grid(axis="y", alpha=0.3)
plt.tight_layout()
plt.savefig(f"{OUTPUT_DIR}/ev_adoption_over_time.png", dpi=150)
plt.close()


# ── Q1 PART 2: BEV vs PHEV over time ─────────────────────────────────────────
print("\n[Q1.2] BEV vs PHEV by model year")
ev_by_type = run_query(f"""
    SELECT Model_Year AS model_year, Electric_Vehicle_Type AS ev_type, COUNT(*) AS ev_count
    FROM `{TABLE}`
    GROUP BY model_year, ev_type
    ORDER BY model_year, ev_type
""")
ev_by_type.to_csv(f"{OUTPUT_DIR}/ev_by_year_type.csv", index=False)

fig, ax = plt.subplots(figsize=(10, 5))
for ev_type, group in ev_by_type.groupby("ev_type"):
    ax.plot(group["model_year"], group["ev_count"], marker="o", label=ev_type)
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{int(x):,}"))
ax.set_title("BEV vs PHEV Adoption Over Time", fontsize=14, fontweight="bold")
ax.set_xlabel("Model Year")
ax.set_ylabel("Registered EV Count")
ax.legend()
ax.grid(axis="y", alpha=0.3)
plt.tight_layout()
plt.savefig(f"{OUTPUT_DIR}/bev_vs_phev.png", dpi=150)
plt.close()


# ── Q2 PART 1: Top counties ───────────────────────────────────────────────────
print("\n[Q2.1] Top 10 counties by EV adoption")
top_counties = run_query(f"""
    SELECT County AS county, COUNT(*) AS ev_count
    FROM `{TABLE}`
    GROUP BY county
    ORDER BY ev_count DESC
    LIMIT 10
""")
top_counties.to_csv(f"{OUTPUT_DIR}/top_counties.csv", index=False)

fig, ax = plt.subplots(figsize=(9, 5))
ax.barh(top_counties["county"][::-1], top_counties["ev_count"][::-1], color="#2ca02c")
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{int(x):,}"))
ax.set_title("Top 10 Counties by EV Adoption", fontsize=14, fontweight="bold")
ax.set_xlabel("EV Count")
ax.grid(axis="x", alpha=0.3)
plt.tight_layout()
plt.savefig(f"{OUTPUT_DIR}/top_counties.png", dpi=150)
plt.close()


# ── Q2 PART 2: Top cities ─────────────────────────────────────────────────────
print("\n[Q2.2] Top 10 cities by EV adoption")
top_cities = run_query(f"""
    SELECT City AS city, County AS county, COUNT(*) AS ev_count
    FROM `{TABLE}`
    GROUP BY city, county
    ORDER BY ev_count DESC
    LIMIT 10
""")
top_cities.to_csv(f"{OUTPUT_DIR}/top_cities.csv", index=False)


# ── Q3 PART 1: Manufacturer market share ─────────────────────────────────────
print("\n[Q3.1] Manufacturer market share")
make_share = run_query(f"""
    WITH make_counts AS (
        SELECT Make AS make, COUNT(*) AS ev_count FROM `{TABLE}` GROUP BY make
    ),
    total AS (SELECT COUNT(*) AS total FROM `{TABLE}`)
    SELECT m.make, m.ev_count, ROUND((m.ev_count / t.total) * 100, 2) AS share_pct
    FROM make_counts m, total t
    ORDER BY share_pct DESC
    LIMIT 10
""")
make_share.to_csv(f"{OUTPUT_DIR}/make_share.csv", index=False)

fig, ax = plt.subplots(figsize=(9, 5))
ax.barh(make_share["make"][::-1], make_share["share_pct"][::-1], color="#ff7f0e")
ax.set_title("Top EV Manufacturers by Market Share", fontsize=14, fontweight="bold")
ax.set_xlabel("Market Share (%)")
ax.grid(axis="x", alpha=0.3)
plt.tight_layout()
plt.savefig(f"{OUTPUT_DIR}/manufacturer_share.png", dpi=150)
plt.close()


# ── Q4: Electric range by adoption group ─────────────────────────────────────
print("\n[Q4] Electric range by adoption group")
range_by_group = run_query(f"""
    WITH high_counties AS (
        SELECT County AS county FROM `{TABLE}` GROUP BY County ORDER BY COUNT(*) DESC LIMIT 10
    ),
    low_counties AS (
        SELECT County AS county FROM `{TABLE}` GROUP BY County HAVING COUNT(*) >= 50 ORDER BY COUNT(*) ASC LIMIT 10
    ),
    labeled AS (
        SELECT e.Electric_Range,
            CASE
                WHEN h.county IS NOT NULL THEN 'HIGH_ADOPTION'
                WHEN l.county IS NOT NULL THEN 'LOW_ADOPTION'
                ELSE 'MID'
            END AS adoption_group
        FROM `{TABLE}` e
        LEFT JOIN high_counties h ON e.County = h.county
        LEFT JOIN low_counties  l ON e.County = l.county
    )
    SELECT adoption_group, COUNT(*) AS n_vehicles,
           ROUND(AVG(Electric_Range), 2) AS avg_range
    FROM labeled
    GROUP BY adoption_group
    ORDER BY adoption_group
""")
range_by_group.to_csv(f"{OUTPUT_DIR}/range_by_adoption_group.csv", index=False)

fig, ax = plt.subplots(figsize=(8, 5))
ax.bar(range_by_group["adoption_group"], range_by_group["avg_range"], color=["#1f77b4","#aec7e8","#ff7f0e"])
ax.set_title("Average Electric Range by Adoption Group", fontsize=14, fontweight="bold")
ax.set_xlabel("Adoption Group")
ax.set_ylabel("Average Electric Range (miles)")
ax.grid(axis="y", alpha=0.3)
plt.tight_layout()
plt.savefig(f"{OUTPUT_DIR}/range_by_adoption_group.png", dpi=150)
plt.close()


print(f"\nAll queries complete. Results and charts saved to /{OUTPUT_DIR}/")
