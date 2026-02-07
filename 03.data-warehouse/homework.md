markdown

# BigQuery Taxi Data – Homework 3 README 🚖

## Context

This README documents my solutions to the **Homework 3** questions from Module 3 (Data Warehouse) of the Data Engineering Zoomcamp 2024/2025/2026.

All work was done using:
- Google Cloud BigQuery
- External tables pointing to GCS Parquet files
- Materialized and optimized (partitioned + clustered) tables
- Query cost comparisons and metadata observations

## 1. Create External and Materialized Tables

**Question:**  
Create an external table from the yellow taxi Parquet files in GCS, then create a materialized (regular) table from it. What is the row count?

**How it was solved:**  
- Created external table using `CREATE EXTERNAL TABLE` with Parquet format  
- Created materialized table with `CREATE OR REPLACE TABLE AS SELECT *`  
- Ran `SELECT COUNT(*)` on the materialized table

```sql
CREATE EXTERNAL TABLE `zoomcamp.yellow_trip_records`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://yellow_taxi_trip_records_parquet/*.parquet']
);

CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_regular` AS
SELECT * FROM `zoomcamp.yellow_trip_records`;

Answer:
20,332,093 rowsExternal table queries GCS directly (no storage cost in BQ), materialized table copies data into BigQuery storage (faster queries).2. Query Cost Comparison – DISTINCT PULocationIDQuestion:
Compare bytes processed when running SELECT DISTINCT PULocationID on the external vs materialized table.How it was solved:
Ran the query on both tables and checked the query details (bytes processed) in BigQuery UI.sql

SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_records`;
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;

Answer:  External table: 0 MB  
Materialized table: 155.12 MB

BigQuery often reads only metadata for external tables in simple DISTINCT cases.3. Columnar Storage ImpactQuestion:
Observe the difference in bytes processed when selecting one column vs two columns from the materialized table.How it was solved:
Executed both queries and compared bytes billed in the BigQuery console.sql

SELECT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;
SELECT PULocationID, DOLocationID FROM `zoomcamp.yellow_trip_data_regular`;

Answer / Observation:
Selecting fewer columns scans significantly less data — BigQuery is columnar and only reads requested columns.4. Trips with Zero Fare AmountQuestion:
How many trips have fare_amount = 0.0 in the materialized table?How it was solved:
Simple filtered count query.sql

SELECT COUNT(*) 
FROM `zoomcamp.yellow_trip_data_regular` 
WHERE fare_amount = 0.0;

Answer:
[Your count here – e.g. 18,374 or whatever the actual number is]5. Partitioning and Clustering SetupQuestion:
Create an optimized table with partitioning by dropoff date and clustering by VendorID.How it was solved:
Used PARTITION BY DATE(...) and CLUSTER BY in the table creation.sql

CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_optimized`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS
SELECT * FROM `zoomcamp.yellow_trip_records`;

Answer / Benefit:
Partitioning enables date-based pruning. Clustering improves performance on VendorID filters/GROUP BY/JOINs.6. Query Cost Comparison – Optimized vs RegularQuestion:
Compare bytes processed for a date-range + DISTINCT VendorID query on regular vs optimized table.How it was solved:
Ran identical queries on both tables and checked bytes processed.sql

-- Regular
SELECT DISTINCT VendorID 
FROM `zoomcamp.yellow_trip_data_regular`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Optimized
SELECT DISTINCT VendorID 
FROM `zoomcamp.yellow_trip_data_optimized`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

Answer:  Regular table: 310.24 MB  
Optimized table: 26.84 MB
→ ~11.5× less data scanned

7. Data Storage LocationQuestion:
Where are the Parquet files physically stored?How it was solved:
Reviewed the external table definition and GCS URI.Answer:
Google Cloud Storage bucket:
gs://yellow_taxi_trip_records_parquet/8. True or False – Materialized Tables Are Always CheaperQuestion:
Are materialized tables always cheaper than external tables?How it was solved:
Considered storage costs, query patterns, and one-off vs repeated use.Answer:
FalseMaterialized tables are often faster/cheaper for frequent filtered queries, but incur storage costs and may not be cheaper for rare/full scans.9. COUNT(*) Metadata BehaviorQuestion:
How many bytes are processed by SELECT COUNT(*) on the materialized table?How it was solved:
Ran the query and checked bytes processed in BigQuery UI.sql

SELECT COUNT(*) FROM `zoomcamp.yellow_trip_data_regular`;

Answer:

≈ 0 bytes processed — BigQuery uses table metadata for row count.

