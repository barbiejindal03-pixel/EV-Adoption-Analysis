# EV-Adoption-Analysis

A multi-tool analytics project focused on understanding electric vehicle (EV) adoption trends using **SAS** for data preparation and analysis, and **R** for visualization and insight communication.

## Project Overview
This project analyzes electric vehicle adoption patterns using publicly available EV registration data.  
The objective is to understand how EV adoption has evolved over time, how it varies across regions, and how it differs by vehicle type and manufacturer.

The project follows a modular analytics workflow, separating data processing from visualization to ensure clarity, reproducibility, and scalability.

## Purpose of the Project
The purpose of this project is to:
- Analyze historical trends in electric vehicle adoption
- Identify geographic patterns in EV adoption across counties and cities
- Compare adoption patterns between BEVs and PHEVs
- Examine manufacturer-level market share
- Produce analysis-ready outputs that can support visualization and further modeling

This project is designed to reflect a real-world analytics pipeline rather than a single-tool or exploratory analysis.

## Tools Used 
This project has been completed using the following multi-tools; 
### SAS
SAS is used for data preparation, aggregation, and analytical table generation.
The raw EV registration dataset is large and structured, making SAS well-suited for:
- Handling high-volume tabular data efficiently
- Performing grouped aggregations and summaries
- Producing clean, analysis-ready output tables
- Ensuring repeatable and auditable data processing

### R
R is used for visualization and insight communication.
Once the data is cleaned and structured in SAS, R is leveraged to:
- Create publication-quality charts
- Compare adoption trends across time, geography, and vehicle types
- Visually highlight concentration and distribution patterns
- Generate reproducible figures directly from code

### Microsoft Word 
Microsoft Word is used for documentation and structured reporting. It supports drafting and refining written interpretations of analytical outputs before they are finalized and published on GitHub.

### Microsoft Excel 
Microsoft Excel is used for lightweight data inspection and validation during the analysis workflow. It is not the core analysis tool but has been used as a supporting tool, to ensure data accuracy and consistency throughout the pipeline.

### Why This Combination
Analysis and communication serve different purposes in an analytics workflow. SAS is used to ensure clean, auditable, and well-structured data processing. It scales efficiently for grouped summaries and is commonly used in regulated, enterprise analytics environments where reproducibility and data integrity matter.
R is then used to turn SAS-generated analysis tables into clear, reproducible visualizations that communicate EV adoption patterns effectively. This separation allows each tool to do what it does best and improves the overall clarity, reproducibility, and maintainability of the analysis.

## Why EVs?
Electric vehicles are a key component of the global transition toward cleaner and more sustainable transportation.  
Analyzing EV adoption helps provide insight into:
- Market readiness for alternative fuel technologies
- Regional differences in adoption behavior
- Technology preference between fully electric and hybrid vehicles
- Shifts in consumer and manufacturer trends over time

## Understanding the Raw Dataset
The raw dataset contains electric vehicle registration records, including information such as:
- Model year
- Vehicle type (BEV or PHEV)
- Manufacturer
- County and city of registration
- Electric range attributes
Before analysis, the raw data requires cleaning, aggregation, and transformation to produce consistent and analysis-ready tables.

## Raw Data Source
**Electric Vehicle Population Data (Data.gov)**  
https://catalog.data.gov/dataset/electric-vehicle-population-data

Raw data files are stored separately in the `raw_data/` folder in the zip format and are not modified directly during analysis. 

## Questions Addressed in This Project
This project is designed as a descriptive analytics study to explore electric vehicle (EV) adoption patterns using real-world registration data. The analysis focuses on the following core themes and questions:

1. EV Adoption Trends Over Time  
- How has the number of registered electric vehicles changed across model years?
- How do adoption trends differ between Battery Electric Vehicles (BEVs) and Plug-in Hybrid Electric Vehicles (PHEVs)?
2. Geographic Distribution of EV Adoption  
- Which counties account for the highest concentration of registered EVs?
- Which cities show the highest levels of EV adoption within those counties?
3. Manufacturer Market Structure  
- Which manufacturers hold the largest share of registered electric vehicles?
- How concentrated is manufacturer market share among the leading EV brands?
4. Vehicle Characteristics Across Adoption Groups  
- How does average electric range vary across high-, mid-, and low-adoption groups?
- Are differences in electric range observable across these adoption categories?
5. Evidence to Support Strategic and Planning Insights
- What do observed adoption, geographic, manufacturer, and policy-related patterns imply for future EV market expansion and infrastructure planning?

## Key Findings
The following findings summarize the main patterns observed from the SAS-generated analysis tables and R visualizations. The results are descriptive in nature and are intended to support interpretation rather than causal inference.

1. EV Adoption Trends Over Time
- Electric vehicle registrations remain very low in earlier model years, followed by a **steady increase** through the 2010s.
- A sharp rise in registrations is visible in recent model years, with noticeable year-to-year variation toward the most recent period.
- Across all model years, Battery Electric Vehicles (BEVs) consistently account for a higher number of registrations than Plug-in Hybrid Electric Vehicles (PHEVs).
- While both BEVs and PHEVs show growth over time, BEVs exhibit a more pronounced increase in later years.

2. Geographic Distribution of EV Adoption
- EV adoption is **not** evenly distributed across regions.
- A small number of counties account for a disproportionately large share of registered electric vehicles.
- A similar concentration pattern is observed at the city level, where one leading city significantly exceeds others in total EV registrations.
- The remaining top counties and cities show varied but substantially lower adoption levels compared to the leading locations.

3. Manufacturer Market Structure
- EV manufacturer market share is highly uneven.
- **Tesla** as a manufacturer holds a substantially larger share of registered electric vehicles than all other manufacturers in the dataset.
- The remaining manufacturers have relatively small and closely grouped market shares, indicating a concentrated market structure among leading brands.

4. Vehicle Characteristics Across Adoption Groups
- Average electric range values across high-, mid-, and low-adoption groups fall within a narrow band of 39–47 miles.
- While differences in average range are observable across adoption groups, these differences are modest in magnitude.
- within my understanding, Adoption is driven more by **infrastructure, incentives, and urban use cases**, not solely by battery capacity or vehicle technology

5. Evidence to Support Strategic and Planning Insights
- EV adoption is highly concentrated geographically, with **King County** emerging as the leading county and **Seattle** as the leading city in terms of registered electric vehicles.
- The strong geographic concentration of EV adoption indicates that infrastructure demand is likely uneven and clustered rather than uniformly distributed.
- The dominance of BEVs and the concentration of manufacturer market share suggest that both technology preference and market structure play a role in observed adoption patterns.
- The relatively similar electric range values across adoption groups imply that factors beyond vehicle range—such as local infrastructure availability, incentives, or regional characteristics—may be associated with differences in adoption intensity.
- Together, these observed patterns provide empirical evidence that can inform future discussion around EV market expansion and infrastructure planning, while recognizing that additional data and modeling would be required to assess causality or policy effectiveness.
  
## Repository Structure
This repository is organized by tool and workflow stage to keep analysis and visualization clearly separated.
- **raw_data/**  
  Original EV registration dataset (Data.gov). No transformations applied. In the ZIP format

- **SAS/**  
  Data cleaning, aggregation, and analytical table generation 
  Outputs are exported as CSVs and summarized in a PDF report

- **R/**  
  Visualization layer.  
  R scripts consume SAS outputs and generate all charts used in this project

- **Root README**  
  Project overview, research questions, methodology, and key findings

  _NOTE:_ Deatiled results are available in the [SAS Analysis](SAS/),[R Visualizations](R/) 




