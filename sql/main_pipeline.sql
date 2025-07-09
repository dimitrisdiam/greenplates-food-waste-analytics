
-- main_pipeline.sql

-- 1. Create Schemas
CREATE SCHEMA IF NOT EXISTS `{{project}}.greenplates_raw`;
CREATE SCHEMA IF NOT EXISTS `{{project}}.greenplates_stage`;
CREATE SCHEMA IF NOT EXISTS `{{project}}.greenplates_prod`;

-- 2. Raw Table
CREATE OR REPLACE TABLE `{{project}}.greenplates_raw.waste_events` (
  event_id STRING,
  event_timestamp TIMESTAMP,
  device_id STRING,
  location STRING,
  category STRING,
  weight_kg FLOAT64
);

-- 3. Staging: Clean & Standardize
CREATE OR REPLACE TABLE `{{project}}.greenplates_stage.cleaned_events` AS
SELECT
  event_id,
  TIMESTAMP_TRUNC(event_timestamp, SECOND) AS event_ts,
  UPPER(TRIM(device_id)) AS device_id,
  INITCAP(TRIM(location)) AS location,
  CASE
    WHEN category IS NULL OR category = '' THEN 'Unknown'
    ELSE INITCAP(TRIM(category))
  END AS category,
  ABS(weight_kg) AS weight_kg
FROM `{{project}}.greenplates_raw.waste_events`
WHERE weight_kg IS NOT NULL;

-- 4. Dim Tables
CREATE OR REPLACE TABLE `{{project}}.greenplates_prod.dim_location` AS
SELECT DISTINCT
  DENSE_RANK() OVER (ORDER BY location) AS location_id,
  location AS location_name
FROM `{{project}}.greenplates_stage.cleaned_events`;

CREATE OR REPLACE TABLE `{{project}}.greenplates_prod.dim_category` AS
SELECT DISTINCT
  DENSE_RANK() OVER (ORDER BY category) AS category_id,
  category AS category_name
FROM `{{project}}.greenplates_stage.cleaned_events`;

-- 5. Fact Table
CREATE OR REPLACE TABLE `{{project}}.greenplates_prod.fact_waste_event` AS
SELECT
  e.event_id,
  e.event_ts,
  l.location_id,
  c.category_id,
  e.weight_kg
FROM `{{project}}.greenplates_stage.cleaned_events` e
JOIN `{{project}}.greenplates_prod.dim_location` l ON e.location = l.location_name
JOIN `{{project}}.greenplates_prod.dim_category` c ON e.category = c.category_name;

-- 6. KPIs
CREATE OR REPLACE TABLE `{{project}}.greenplates_prod.kpi_weekly_location` AS
SELECT
  l.location_name,
  FORMAT_TIMESTAMP('%G-W%V', event_ts) AS iso_week,
  SUM(weight_kg) AS total_waste_kg
FROM `{{project}}.greenplates_prod.fact_waste_event` f
JOIN `{{project}}.greenplates_prod.dim_location` l ON f.location_id = l.location_id
GROUP BY location_name, iso_week;

CREATE OR REPLACE TABLE `{{project}}.greenplates_prod.kpi_monthly_category` AS
SELECT
  c.category_name,
  FORMAT_TIMESTAMP('%Y-%m', event_ts) AS month,
  SUM(weight_kg) AS total_waste_kg
FROM `{{project}}.greenplates_prod.fact_waste_event` f
JOIN `{{project}}.greenplates_prod.dim_category` c ON f.category_id = c.category_id
GROUP BY category_name, month;

-- 7. Data Quality Checks
-- Duplicates
SELECT event_id, COUNT(*) AS cnt FROM `{{project}}.greenplates_stage.cleaned_events`
GROUP BY event_id HAVING cnt > 1;

-- Non-positive weights
SELECT COUNT(*) AS non_positive FROM `{{project}}.greenplates_stage.cleaned_events` WHERE weight_kg <= 0;

-- Missing categories
SELECT COUNT(*) AS missing_category FROM `{{project}}.greenplates_stage.cleaned_events` WHERE category = 'Unknown';
