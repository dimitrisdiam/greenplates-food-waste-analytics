
# Troubleshooting Guide

## Common Issues & SQL Fixes

### 1. Duplicate Events
```sql
SELECT event_id, COUNT(*) FROM greenplates_stage.cleaned_events
GROUP BY event_id HAVING COUNT(*) > 1;
```

### 2. Negative or Zero Weight
```sql
SELECT * FROM greenplates_stage.cleaned_events
WHERE weight_kg <= 0;
```

### 3. Missing Category
```sql
SELECT * FROM greenplates_stage.cleaned_events
WHERE category = 'Unknown';
```
