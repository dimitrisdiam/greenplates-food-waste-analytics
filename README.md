# GreenPlates – Food Waste Analytics 📊🥦

A data pipeline simulation designed to highlight your skills in SQL, data cleaning, transformation, and KPI monitoring — all within the context of reducing food waste in the hospitality industry.

---

## 🌱 Project Overview

**GreenPlates** simulates a real-world scenario in which IoT sensors measure food waste across multiple restaurant locations. This project is focused on building a scalable and clean SQL-based pipeline using BigQuery-style queries.

It includes:
- A **synthetic dataset** of 15,000 food waste events
- A complete **SQL pipeline** from raw ingestion to KPIs
- Built-in **data quality checks** and transformations
- Documentation to simulate real data support scenarios

---

## 🗂 Project Structure

├── data/
│ └── raw/
│ └── waste_events.csv # Synthetic IoT-based food waste logs
├── docs/
│ ├── data_dictionary.md # Column descriptions
│ └── troubleshooting.md # SQL snippets to fix common issues
├── sql/
│ └── main_pipeline.sql # Full SQL pipeline (7 sections)
├── README.md # You're reading it!


---

## ⚙️ Pipeline Flow

1. **Ingest Raw Data**
   - CSV data from simulated IoT waste events
   - Columns: `event_id`, `event_timestamp`, `device_id`, `location`, `category`, `weight_kg`

2. **Staging / Cleaning**
   - Strip whitespace, normalize text casing
   - Fix missing categories (replace with `"Unknown"`)
   - Convert negative weights to absolute values
   - Remove null weights

3. **Dimension Tables**
   - `dim_location`: List of unique locations with ID
   - `dim_category`: List of unique food categories with ID

4. **Fact Table**
   - Joins cleaned data with dimensions to create `fact_waste_event`
   - Stores normalized records with foreign keys

5. **KPI Outputs**
   - Total waste by week & location
   - Monthly waste trends by category

6. **Data Quality Checks**
   - Duplicates
   - Missing or invalid weights
   - Blank or unknown categories
