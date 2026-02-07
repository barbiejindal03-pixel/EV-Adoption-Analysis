Project: EV Adoption Analysis
Tool: SAS Studio (Web)
Dataset: Electric Vehicle Population Data (Data.gov)

Description:
- Aggregates EV registrations by year
- Compares BEV vs PHEV adoption
- Identifies top cities and counties
- Analyzes electric range by adoption group

/* Generated Code (IMPORT) */
/* Source File: Electric_Vehicle_Population_Data.csv */
/* Source Path: /home/u64356871 */
%web_drop_table(WORK.IMPORT);

/* Q1: Adoption trends over time */
/* Q2: Geographic distribution */
/* Q3: Manufacturer market structure */
/* Q4: Vehicle characteristics & adoption */

FILENAME REFFILE '/home/u64356871/Electric_Vehicle_Population_Data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

/* Q1, PART 1: EV adoption trend over time */

PROC SQL;
    CREATE TABLE WORK.ev_by_year AS
    SELECT 
        "Model Year"n AS model_year,
        COUNT(*) AS ev_count
    FROM WORK.IMPORT
    GROUP BY "Model Year"n
    ORDER BY "Model Year"n;
QUIT;

PROC PRINT DATA=WORK.ev_by_year (OBS=25);
RUN;

/* Q1, PART 2: EV adoption trends by vehicle type (BEV vs PHEV) */

PROC SQL;
    CREATE TABLE WORK.ev_by_year_type AS
    SELECT 
        "Model Year"n AS model_year,
        "Electric Vehicle Type"n AS ev_type,
        COUNT(*) AS ev_count
    FROM WORK.IMPORT
    GROUP BY 
        "Model Year"n,
        "Electric Vehicle Type"n
    ORDER BY 
        "Model Year"n,
        "Electric Vehicle Type"n;
QUIT;

PROC PRINT DATA=WORK.ev_by_year_type (OBS=40);
RUN;

/* Q2, PART 1: Top counties by EV adoption */

PROC SQL OUTOBS=20;
    CREATE TABLE WORK.top_counties AS
    SELECT 
        "County"n AS county,
        COUNT(*) AS ev_count
    FROM WORK.IMPORT
    GROUP BY "County"n
    ORDER BY ev_count DESC;
QUIT;

PROC PRINT DATA=WORK.top_counties;
RUN;

/* Q2, PART 2: Top cities by EV adoption */

PROC SQL OUTOBS=30;
    CREATE TABLE WORK.top_cities AS
    SELECT 
        "City"n   AS city,
        "County"n AS county,
        COUNT(*)  AS ev_count
    FROM WORK.IMPORT
    GROUP BY "City"n, "County"n
    ORDER BY ev_count DESC;
QUIT;

PROC PRINT DATA=WORK.top_cities;
RUN;

/* Q3, PART 1: manufacturers hold the largest share of registered electric vehicles */
PROC SQL;
    CREATE TABLE WORK.make_counts AS
    SELECT 
        "Make"n AS make,
        COUNT(*) AS ev_count
    FROM WORK.IMPORT
    GROUP BY "Make"n
    ORDER BY ev_count DESC;
QUIT;

PROC SQL;
    CREATE TABLE WORK.make_share AS
    SELECT 
        a.make,
        a.ev_count,
        (a.ev_count / b.total)*100 AS share_pct FORMAT=6.2
    FROM WORK.make_counts a,
         (SELECT COUNT(*) AS total FROM WORK.IMPORT) b
    ORDER BY share_pct DESC;
QUIT;

PROC PRINT DATA=WORK.make_share (OBS=20);
RUN;

/* Q3, PART 2: manufacturer market share varies across counties */

PROC SQL;
    CREATE TABLE WORK.make_by_county AS
    SELECT 
        "County"n AS county,
        "Make"n   AS make,
        COUNT(*)  AS ev_count
    FROM WORK.IMPORT
    GROUP BY "County"n, "Make"n;
QUIT;

PROC SQL;
    CREATE TABLE WORK.make_by_county_share AS
    SELECT 
        a.county,
        a.make,
        a.ev_count,
        (a.ev_count / b.county_total)*100 AS share_pct FORMAT=6.2
    FROM WORK.make_by_county a
    JOIN (
        SELECT 
            "County"n AS county,
            COUNT(*) AS county_total
        FROM WORK.IMPORT
        GROUP BY "County"n
    ) b
    ON a.county = b.county
    ORDER BY a.county, share_pct DESC;
QUIT;

/* Q3, PART 3: manufacturer market share varies across cities (Top 50 cities only) */

PROC SQL OUTOBS=50;
    CREATE TABLE WORK.top_cities_50 AS
    SELECT 
        "City"n   AS city,
        "County"n AS county,
        COUNT(*)  AS ev_count
    FROM WORK.IMPORT
    GROUP BY "City"n, "County"n
    ORDER BY ev_count DESC;
QUIT;

PROC SQL;
    CREATE TABLE WORK.make_by_top_cities AS
    SELECT 
        t.city,
        t.county,
        e."Make"n AS make,
        COUNT(*) AS ev_count
    FROM WORK.IMPORT e
    INNER JOIN WORK.top_cities_50 t
        ON e."City"n = t.city AND e."County"n = t.county
    GROUP BY t.city, t.county, e."Make"n;
QUIT;

PROC SQL;
    CREATE TABLE WORK.make_by_top_cities_share AS
    SELECT 
        a.city,
        a.county,
        a.make,
        a.ev_count,
        (a.ev_count / b.city_total)*100 AS share_pct FORMAT=6.2
    FROM WORK.make_by_top_cities a
    JOIN (
        SELECT 
            city,
            county,
            SUM(ev_count) AS city_total
        FROM WORK.make_by_top_cities
        GROUP BY city, county
    ) b
    ON a.city = b.city AND a.county = b.county
    ORDER BY a.city, share_pct DESC;
QUIT;

/* Q4, PART 1: define high-adoption and low-adoption counties based on EV counts */

PROC SQL;
    CREATE TABLE WORK.county_adoption AS
    SELECT 
        "County"n AS county,
        COUNT(*) AS ev_count
    FROM WORK.IMPORT
    GROUP BY "County"n
    ORDER BY ev_count DESC;
QUIT;

/* High-adoption counties = Top 10 counties by EV count */
PROC SQL OUTOBS=10;
    CREATE TABLE WORK.high_counties AS
    SELECT county, ev_count
    FROM WORK.county_adoption
    ORDER BY ev_count DESC;
QUIT;

/* Low-adoption counties = Bottom 10 counties with at least 50 EVs (avoid tiny-count noise) */
PROC SQL OUTOBS=10;
    CREATE TABLE WORK.low_counties AS
    SELECT county, ev_count
    FROM WORK.county_adoption
    WHERE ev_count >= 50
    ORDER BY ev_count ASC;
QUIT;

PROC PRINT DATA=WORK.high_counties;
RUN;

PROC PRINT DATA=WORK.low_counties;
RUN;


/* Q4, PART 2: do high-adoption regions have higher electric range than low-adoption regions? */

PROC SQL;
    CREATE TABLE WORK.range_by_adoption_group AS
    SELECT
        CASE 
          WHEN h.county IS NOT NULL THEN "HIGH_ADOPTION"
          WHEN l.county IS NOT NULL THEN "LOW_ADOPTION"
          ELSE "MID"
        END AS adoption_group,
        COUNT(*) AS n_vehicles,
        MEAN("Electric Range"n)   AS avg_range    FORMAT=6.2,
        MEDIAN("Electric Range"n) AS median_range FORMAT=6.2,
        MIN("Electric Range"n)    AS min_range    FORMAT=6.2,
        MAX("Electric Range"n)    AS max_range    FORMAT=6.2
    FROM WORK.IMPORT e
    LEFT JOIN WORK.high_counties h ON e."County"n = h.county
    LEFT JOIN WORK.low_counties  l ON e."County"n = l.county
    GROUP BY adoption_group;
QUIT;

PROC PRINT DATA=WORK.range_by_adoption_group;
RUN;

/* Q4, PART 3: how do vehicle characteristics differ between high-adoption and low-adoption regions? (EV type mix) */

PROC SQL;
    CREATE TABLE WORK.evtype_mix_by_group AS
    SELECT 
        adoption_group,
        "Electric Vehicle Type"n AS ev_type,
        COUNT(*) AS ev_count
    FROM (
        SELECT 
            e.*,
            CASE 
              WHEN h.county IS NOT NULL THEN "HIGH_ADOPTION"
              WHEN l.county IS NOT NULL THEN "LOW_ADOPTION"
              ELSE "MID"
            END AS adoption_group
        FROM WORK.IMPORT e
        LEFT JOIN WORK.high_counties h ON e."County"n = h.county
        LEFT JOIN WORK.low_counties  l ON e."County"n = l.county
    ) t
    GROUP BY adoption_group, "Electric Vehicle Type"n
    ORDER BY adoption_group, ev_count DESC;
QUIT;

PROC PRINT DATA=WORK.evtype_mix_by_group;
RUN;

/* Q4, PART 4: how do vehicle characteristics differ between high-adoption and low-adoption regions? */

PROC SQL;
    CREATE TABLE WORK.cafv_mix_by_group AS
    SELECT 
        adoption_group,
        "Clean Alternative Fuel Vehicle (CAFV) Eligibility"n AS cafv_status,
        COUNT(*) AS ev_count
    FROM (
        SELECT 
            e.*,
            CASE 
              WHEN h.county IS NOT NULL THEN "HIGH_ADOPTION"
              WHEN l.county IS NOT NULL THEN "LOW_ADOPTION"
              ELSE "MID"
            END AS adoption_group
        FROM WORK.IMPORT e
        LEFT JOIN WORK.high_counties h ON e."County"n = h.county
        LEFT JOIN WORK.low_counties  l ON e."County"n = l.county
    ) t
    GROUP BY adoption_group, "Clean Alternative Fuel Vehicle (CAFV) Eligibility"n
    ORDER BY adoption_group, ev_count DESC;
QUIT;
