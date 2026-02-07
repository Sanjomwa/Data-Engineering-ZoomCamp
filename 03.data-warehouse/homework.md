# BigQuery Taxi Data – Homework 3 README 🚖

## Context

This README documents my solutions to the **Homework 3** questions from Module 3 (Data Warehouse) of the Data Engineering Zoomcamp 2024/2025/2026.

All work was done using:
- Google Cloud BigQuery
- External tables pointing to GCS Parquet files
- Materialized and optimized (partitioned + clustered) tables
- Query cost comparisons and metadata observations

This assignment explores external tables, materialized tables, query costs, and optimization techniques in BigQuery using the NYC Yellow Taxi dataset.

## 1. Create External and Materialized Tables

**Question:**  
Create an external table from the yellow taxi Parquet files in GCS, then create a materialized (regular) table from it. What is the row count?

**How it was solved:**  
Created external table using `CREATE EXTERNAL TABLE` with Parquet format and GCS URIs.  
Created materialized table with `CREATE OR REPLACE TABLE AS SELECT *`.  
Ran `SELECT COUNT(*)` on the materialized table.

```sql
CREATE EXTERNAL TABLE `zoomcamp.yellow_trip_records`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://yellow_taxi_trip_records_parquet/*.parquet']
);

CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_regular` AS
SELECT *
FROM `zoomcamp.yellow_trip_records`;

Answer:
Row count = 20,332,093.Both external and materialized tables return the same data, but performance differs. External tables query directly from GCS, while materialized tables store data inside BigQuery for faster queries.Reference: BigQuery external tables (cloud.google.com in Bing)2. Query Cost ComparisonQuestion:
Compare bytes processed when running SELECT DISTINCT PULocationID on the external vs materialized table.How it was solved:
Executed the same DISTINCT query on both tables and checked bytes processed in the BigQuery console / query details.sql

SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_records`;
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;

Answer:
External table: 0 MB processed (metadata only).
Materialized table: 155.12 MB processed.BigQuery scans actual column data in materialized tables.Reference: BigQuery query processing overview (cloud.google.com in Bing)3. Columnar Storage ImpactQuestion:
Observe the difference in bytes processed when selecting one column vs two columns from the materialized table.How it was solved:
Ran both SELECT queries on the materialized table and compared bytes billed/scanned in BigQuery UI.sql

SELECT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;
SELECT PULocationID, DOLocationID FROM `zoomcamp.yellow_trip_data_regular`;

Answer:
BigQuery is columnar. Querying one column scans less data than querying two.Reference: BigQuery storage overview (cloud.google.com in Bing)4. Trips with Zero FareQuestion:
How many trips have fare_amount = 0.0?How it was solved:
Filtered count query on the materialized table.sql

SELECT COUNT(*) 
FROM `zoomcamp.yellow_trip_data_regular` 
WHERE fare_amount = 0.0;

Answer:
Count = 8,333.These records represent free trips, errors, or test data.Reference: Best practices for data analysis (cloud.google.com in Bing)5. Partitioning and ClusteringQuestion:
Create an optimized table partitioned by dropoff date and clustered by VendorID.How it was solved:
Used PARTITION BY DATE(tpep_dropoff_datetime) and CLUSTER BY VendorID during table creation from the external table.sql

CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_optimized`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS
SELECT *
FROM `zoomcamp.yellow_trip_records`;

Answer:
Partitioning by tpep_dropoff_datetime and clustering by VendorID reduces query cost and improves performance.Reference: Partitioned tables (cloud.google.com in Bing), Clustered tables (cloud.google.com in Bing)6. Query Cost with OptimizationQuestion:
Compare bytes scanned for a date-range DISTINCT VendorID query on regular vs optimized table.How it was solved:
Ran identical filtered DISTINCT queries on both tables and checked bytes processed.sql

-- Regular table
SELECT DISTINCT VendorID 
FROM `zoomcamp.yellow_trip_data_regular`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Optimized table
SELECT DISTINCT VendorID 
FROM `zoomcamp.yellow_trip_data_optimized`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

Answer:
Regular table: 310.24 MB scanned.
Optimized table: 26.84 MB scanned.Partitioning and clustering significantly reduce scanned data.Reference: BigQuery cost optimization (cloud.google.com in Bing)7. Data SourceQuestion:
Where are the Parquet files physically stored?How it was solved:
Reviewed the external table OPTIONS (URIs) and GCS path.Answer:
Data is stored in a Google Cloud Storage bucket (gs://yellow_taxi_trip_records_parquet/).Reference: External data sources (cloud.google.com in Bing)8. True/False – Materialized Tables Are Always CheaperQuestion:
“Materialized tables are always cheaper.” True or False?How it was solved:
Considered storage vs query costs, partitioning/clustering impact, and one-off vs repeated query scenarios.Answer:
False.Materialized tables are often faster and cheaper, but not always. Query cost depends on partitioning, clustering, and query type.Reference: Materialized views (cloud.google.com in Bing)9. COUNT(*) QueryQuestion:
How many bytes are processed by a simple SELECT COUNT(*) on the materialized table?How it was solved:
Executed the query and inspected bytes processed in BigQuery UI.sql

SELECT COUNT(*) FROM `zoomcamp.yellow_trip_data_regular`;

Answer:
Estimated bytes processed = near zero.BigQuery answers COUNT(*) using row metadata, not by scanning all columns.Reference: COUNT function (cloud.google.com in Bing)Lessons LearnedExternal tables are useful for quick access but less efficient for queries.
Materialized tables improve performance by storing data inside BigQuery.
BigQuery’s columnar storage means query cost depends on the number of columns scanned.
Partitioning and clustering are critical for reducing query cost.
Metadata queries (COUNT(*)) can avoid full scans, saving resources.

How to Run LocallyEnable BigQuery and GCS in your Google Cloud project.
Upload the dataset (NYC Yellow Taxi Parquet files) to a GCS bucket.
Create an external table in BigQuery pointing to the bucket.
Materialize the table inside BigQuery for faster queries.
Run the SQL queries above in the BigQuery console or CLI.
Compare query costs using the Query Validator before execution.

