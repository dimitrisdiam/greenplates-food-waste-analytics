
# Data Dictionary

## Raw Table: waste_events
| Column         | Type      | Description                       |
|----------------|-----------|-----------------------------------|
| event_id       | STRING    | Unique identifier for each event |
| event_timestamp| TIMESTAMP | When the waste was recorded      |
| device_id      | STRING    | Identifier for the sensor device |
| location       | STRING    | City of the event                |
| category       | STRING    | Food category (e.g., Meat, Fruit)|
| weight_kg      | FLOAT64   | Measured weight in kilograms     |
