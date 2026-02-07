# BigQuery Taxi Data – Homework 3 README 🚖

## Context

This README documents my solutions to the **Homework 3** questions from Module 3 **(Data Warehouse)** of the Data Engineering Zoomcamp 2026.

All work was done using:
- Google Cloud BigQuery
- External tables pointing to GCS Parquet files
- Materialized and optimized (partitioned + clustered) tables
- Query cost comparisons and metadata observations

This assignment explores external tables, materialized tables, query costs, and optimization techniques in BigQuery using the NYC Yellow Taxi dataset.

**1. Create External and Materialized Tables**
**Question:**  
Create a table that is partitioned by the dropoff datetime and clustered by VendorID. What is the number of rows in the table?

_(Note: the question asks for the row count after creating the external table and then the materialized/regular table from it.)_

**How it was solved:**

Created external table from GCS Parquet files.  
Created materialized (regular) table by copying data from external table.  
Counted rows on the materialized table.

```sql
CREATE EXTERNAL TABLE `zoomcamp.yellow_trip_records`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://yellow_taxi_trip_records_parquet/*.parquet']
);

CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_regular` AS
SELECT *
FROM `zoomcamp.yellow_trip_records`;
```
**Answer:**
Row count = 20,332,093.Both external and materialized tables return the same data, but performance differs. External tables query directly from GCS, while materialized tables store data inside BigQuery for faster queries.

**2. Query Cost Comparison**
**Question:**
What is the amount of data processed when running SELECT DISTINCT PULocationID on the external table vs the materialized table?How it was solved:Executed SELECT DISTINCT PULocationID on both external and materialized tables.
Checked bytes processed in BigQuery query details.sql

```sql
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_records`;
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;
```
**Answer:**
External table: 0 MB processed (metadata only).
Materialized table: 155.12 MB processed.BigQuery scans actual column data in materialized tables.

**3. Columnar Storage Impact**
**Question:**
What is the amount of data processed when selecting one column vs two columns from the materialized table?How it was solved:Ran SELECT on one column, then on two columns from the materialized table.
Compared bytes processed in BigQuery UI.sql
```sql
SELECT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;
SELECT PULocationID, DOLocationID FROM `zoomcamp.yellow_trip_data_regular`;
```
**Answer:**
BigQuery is columnar. Querying one column scans less data than querying two.

**4. Trips with Zero Fare**
**Question:**
How many trips have a fare amount of zero?How it was solved:Filtered count on fare_amount = 0.0 in materialized table.sql
```sql
SELECT COUNT(*) 
FROM `zoomcamp.yellow_trip_data_regular` 
WHERE fare_amount = 0.0;
```
**Answer:**
Count = 8,333.These records represent free trips.

**5. Partitioning and Clustering**
**Question:**
Create a partitioned and clustered table. What is the benefit of partitioning and clustering in this case?How it was solved:Created optimized table with date partitioning and VendorID clustering from the external table source.sql
```sql
CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_optimized`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS
SELECT *
FROM `zoomcamp.yellow_trip_records`;
```
**Answer:**
Partitioning by tpep_dropoff_datetime and clustering by VendorID reduces query cost and improves performance.

**6. Query Cost with Optimization
Question:**
What is the amount of data processed when running a query with a date filter and DISTINCT on VendorID on the regular table vs the optimized table?How it was solved:Ran date-range + DISTINCT VendorID query on regular table and on optimized table.
Compared bytes scanned.sql
```sql
-- Regular table
SELECT DISTINCT VendorID 
FROM `zoomcamp.yellow_trip_data_regular`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Optimized table
SELECT DISTINCT VendorID 
FROM `zoomcamp.yellow_trip_data_optimized`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
```
**Answer:**
Regular table: 310.24 MB scanned.
Optimized table: 26.84 MB scanned.
Partitioning and clustering significantly reduce scanned data.

**7. Data Source
Question:**
Where are the Parquet files stored?
How it was solved:Checked the URIs in the external table definition.
**Answer:**
Data is stored in a Google Cloud Storage bucket (gs://yellow_taxi_trip_records_parquet/).

**8. True/False – Materialized Tables Are Always Cheaper
Question:**
True or false: Materialized tables are always cheaper than external tables.How it was solved:Evaluated storage costs, query patterns, and optimization factors.
**Answer:**
False.
Materialized tables are often faster and cheaper, but not always. Query cost depends on partitioning, clustering, and query type.

**9. COUNT(*) Query
Question:**
What is the amount of data processed when running SELECT COUNT(*) on the materialized table?How it was solved:Executed simple COUNT(*) and checked bytes processed in BigQuery UI.sql
```sql
SELECT COUNT(*) FROM `zoomcamp.yellow_trip_data_regular`;
```
**Answer:**
Estimated bytes processed = near zero.BigQuery answers COUNT(*) using row metadata, not by scanning all columns.

**Lessons Learned**
- External tables are useful for quick access but less efficient for queries.
- Materialized tables improve performance by storing data inside BigQuery.
- BigQuery’s columnar storage means query cost depends on the number of columns scanned.
- Partitioning and clustering are critical for reducing query cost.
- Metadata queries (COUNT(*)) can avoid full scans, saving resources.

**How to Run LocallyEnable BigQuery and GCS in your Google Cloud project.**
- Upload the dataset (NYC Yellow Taxi Parquet files) to a GCS bucket.
- Create an external table in BigQuery pointing to the bucket.
- Materialize the table inside BigQuery for faster queries.
- Run the SQL queries above in the BigQuery console or CLI.
- Compare query costs using the Query Validator before execution.

