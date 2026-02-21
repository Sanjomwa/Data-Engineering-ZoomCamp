# Homework 5 – Data Platforms  
**Data Engineering Zoomcamp 2026**  
Due: 1 March 2026

---

## Question 1. Bruin Pipeline Structure
In a Bruin project, what are the required files/directories?  
✅ **Answer:** `.bruin.yml` and `pipeline/` (containing `pipeline.yml` and `assets/`)

---

## Question 2. Materialization Strategies
You're building a pipeline that processes NYC taxi data organized by month based on `pickup_datetime`.
Which incremental strategy is best for processing a specific interval period by deleting and inserting data for that time period?  
✅ **Answer:** `time_interval`

---

## Question 3. Pipeline Variables
You have a variable defined in `pipeline.yml`:

```yaml
variables:
  taxi_types:
    type: array
    items:
      type: string
    default: ["yellow", "green"]
```
How do you override this when running the pipeline to only process yellow taxis?
✅ Answer:
```bash
bruin run --var 'taxi_types=["yellow"]'
```

Question 4. Running with Dependencies
You've modified the ingestion/trips.py asset and want to run it plus all downstream assets. Which command should you use?
✅ Answer:
```bash
bruin run --downstream
```

Question 5. Quality Checks
You want to ensure the pickup_datetime column in your trips table never has NULL values. Which quality check should you add to your asset definition?
✅ Answer: `not_null: true`

Question 6. Lineage and Dependencies
After building your pipeline, you want to visualize the dependency graph between assets. Which Bruin command should you use?
✅ Answer: `bruin lineage`
Example:
```bash
bruin lineage data-platform/nyc-taxi/assets/staging/trips_summary.sql
```
Output:

Upstream: raw.trips_raw, raw.taxi_zone_lookup, raw.payment_lookup

Downstream: reports.report_trips_monthly

Question 7. First-Time Run
You're running a Bruin pipeline for the first time on a new DuckDB database. What flag should you use to ensure tables are created from scratch?
✅ Answer: `--full-refresh`

Notes
Bruin validate checks syntax and dependencies quickly.

Bruin run executes pipelines or assets.

Bruin run --downstream runs an asset plus all downstream dependencies.

Bruin lineage shows upstream/downstream dependencies.

Bruin query allows ad‑hoc SQL queries against connections.

Adding "green" to taxi_types ensures both yellow and green taxi datasets are ingested.

Quality checks validate data integrity (e.g., uniqueness, non‑nulls, positive values).
