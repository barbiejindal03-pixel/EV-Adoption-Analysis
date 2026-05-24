-- ============================================================
-- EV Adoption & Market Analysis — BigQuery SQL
-- Author: Barbie Jindal
-- Project: ev-adoption-analysis-497223
-- Table: ev_project.ev_population
-- ============================================================


-- -------------------------------------------------------
-- Q1 PART 1: EV adoption trend over time (by model year)
-- -------------------------------------------------------
SELECT
  `Model Year` AS model_year,
  COUNT(*) AS ev_count
FROM `ev-adoption-analysis-497223.ev_project.ev_population`
GROUP BY `Model Year`
ORDER BY `Model Year`;


-- -------------------------------------------------------
-- Q1 PART 2: BEV vs PHEV adoption trends over time
-- -------------------------------------------------------
SELECT
  `Model Year` AS model_year,
  `Electric Vehicle Type` AS ev_type,
  COUNT(*) AS ev_count
FROM `ev-adoption-analysis-497223.ev_project.ev_population`
GROUP BY `Model Year`, `Electric Vehicle Type`
ORDER BY `Model Year`, `Electric Vehicle Type`;


-- -------------------------------------------------------
-- Q2 PART 1: Top 20 counties by EV adoption
-- -------------------------------------------------------
SELECT
  County AS county,
  COUNT(*) AS ev_count
FROM `ev-adoption-analysis-497223.ev_project.ev_population`
GROUP BY County
ORDER BY ev_count DESC
LIMIT 20;


-- -------------------------------------------------------
-- Q2 PART 2: Top 30 cities by EV adoption
-- -------------------------------------------------------
SELECT
  City AS city,
  County AS county,
  COUNT(*) AS ev_count
FROM `ev-adoption-analysis-497223.ev_project.ev_population`
GROUP BY City, County
ORDER BY ev_count DESC
LIMIT 30;


-- -------------------------------------------------------
-- Q3 PART 1: Manufacturer market share (top 20)
-- -------------------------------------------------------
WITH make_counts AS (
  SELECT Make AS make, COUNT(*) AS ev_count
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY Make
),
total AS (
  SELECT COUNT(*) AS total
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
)
SELECT
  m.make,
  m.ev_count,
  ROUND((m.ev_count / t.total) * 100, 2) AS share_pct
FROM make_counts m, total t
ORDER BY share_pct DESC
LIMIT 20;


-- -------------------------------------------------------
-- Q3 PART 2: Manufacturer market share by county
-- -------------------------------------------------------
WITH make_by_county AS (
  SELECT County AS county, Make AS make, COUNT(*) AS ev_count
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County, Make
),
county_totals AS (
  SELECT County AS county, COUNT(*) AS county_total
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County
)
SELECT
  m.county,
  m.make,
  m.ev_count,
  ROUND((m.ev_count / c.county_total) * 100, 2) AS share_pct
FROM make_by_county m
JOIN county_totals c ON m.county = c.county
ORDER BY m.county, share_pct DESC;


-- -------------------------------------------------------
-- Q4 PART 1: Top 10 high-adoption counties
-- -------------------------------------------------------
SELECT County AS county, COUNT(*) AS ev_count
FROM `ev-adoption-analysis-497223.ev_project.ev_population`
GROUP BY County
ORDER BY ev_count DESC
LIMIT 10;


-- -------------------------------------------------------
-- Q4 PART 2: Average electric range by adoption group
-- -------------------------------------------------------
WITH high_counties AS (
  SELECT County AS county
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County ORDER BY COUNT(*) DESC LIMIT 10
),
low_counties AS (
  SELECT County AS county
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County HAVING COUNT(*) >= 50
  ORDER BY COUNT(*) ASC LIMIT 10
),
labeled AS (
  SELECT
    `Electric Range`,
    CASE
      WHEN h.county IS NOT NULL THEN 'HIGH_ADOPTION'
      WHEN l.county IS NOT NULL THEN 'LOW_ADOPTION'
      ELSE 'MID'
    END AS adoption_group
  FROM `ev-adoption-analysis-497223.ev_project.ev_population` e
  LEFT JOIN high_counties h ON e.County = h.county
  LEFT JOIN low_counties  l ON e.County = l.county
)
SELECT
  adoption_group,
  COUNT(*) AS n_vehicles,
  ROUND(AVG(`Electric Range`), 2) AS avg_range,
  ROUND(MIN(`Electric Range`), 2) AS min_range,
  ROUND(MAX(`Electric Range`), 2) AS max_range
FROM labeled
GROUP BY adoption_group
ORDER BY adoption_group;


-- -------------------------------------------------------
-- Q4 PART 3: EV type mix by adoption group
-- -------------------------------------------------------
WITH high_counties AS (
  SELECT County AS county
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County ORDER BY COUNT(*) DESC LIMIT 10
),
low_counties AS (
  SELECT County AS county
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County HAVING COUNT(*) >= 50
  ORDER BY COUNT(*) ASC LIMIT 10
),
labeled AS (
  SELECT
    `Electric Vehicle Type`,
    CASE
      WHEN h.county IS NOT NULL THEN 'HIGH_ADOPTION'
      WHEN l.county IS NOT NULL THEN 'LOW_ADOPTION'
      ELSE 'MID'
    END AS adoption_group
  FROM `ev-adoption-analysis-497223.ev_project.ev_population` e
  LEFT JOIN high_counties h ON e.County = h.county
  LEFT JOIN low_counties  l ON e.County = l.county
)
SELECT
  adoption_group,
  `Electric Vehicle Type` AS ev_type,
  COUNT(*) AS ev_count
FROM labeled
GROUP BY adoption_group, `Electric Vehicle Type`
ORDER BY adoption_group, ev_count DESC;


-- -------------------------------------------------------
-- Q4 PART 4: CAFV eligibility mix by adoption group
-- -------------------------------------------------------
WITH high_counties AS (
  SELECT County AS county
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County ORDER BY COUNT(*) DESC LIMIT 10
),
low_counties AS (
  SELECT County AS county
  FROM `ev-adoption-analysis-497223.ev_project.ev_population`
  GROUP BY County HAVING COUNT(*) >= 50
  ORDER BY COUNT(*) ASC LIMIT 10
),
labeled AS (
  SELECT
    `Clean Alternative Fuel Vehicle _CAFV_ Eligibility` AS cafv_status,
    CASE
      WHEN h.county IS NOT NULL THEN 'HIGH_ADOPTION'
      WHEN l.county IS NOT NULL THEN 'LOW_ADOPTION'
      ELSE 'MID'
    END AS adoption_group
  FROM `ev-adoption-analysis-497223.ev_project.ev_population` e
  LEFT JOIN high_counties h ON e.County = h.county
  LEFT JOIN low_counties  l ON e.County = l.county
)
SELECT
  adoption_group,
  cafv_status,
  COUNT(*) AS ev_count
FROM labeled
GROUP BY adoption_group, cafv_status
ORDER BY adoption_group, ev_count DESC;
