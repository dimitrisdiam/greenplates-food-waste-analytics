
# GreenPlates – Food Waste Analytics

A clean, SQL-first data pipeline simulation for waste measurement in the hospitality industry.

## Features
- Synthetic IoT-based food waste logs (15,000+ records)
- BigQuery SQL pipeline: raw → stage → dim/fact → KPIs
- Data quality checks and missing value handling

## How to Use
1. Replace `{{project}}` in `main_pipeline.sql` with your GCP project ID.
2. Load `data/raw/waste_events.csv` to BigQuery table `greenplates_raw.waste_events`.
3. Run `sql/main_pipeline.sql` in BigQuery console or use `bq` CLI.
4. Explore generated tables and KPIs.

## Ideal For
- Data support analyst roles
- BI/data engineering candidates
- Interview take-home tasks
