**Homework 3 – BigQuery**

**Q1. Create External and Materialized Tables**
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
Row count = 20,332,093.
Both external and materialized tables return the same data, but performance differs.
External tables query directly from GCS, while materialized tables store data inside BigQuery for faster queries.
***
**Q2. Query Cost Comparison**
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_records`;
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;
Answer:

External table: 0 MB processed (metadata only).
Materialized table: 155.12 MB processed.

BigQuery scans actual column data in materialized tables.
***
**Q3. Columnar Storage Impact**
SELECT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;
SELECT PULocationID, DOLocationID FROM `zoomcamp.yellow_trip_data_regular`;
Answer:
BigQuery is columnar. Querying one column scans less data than querying two.
***
**Q4. Trips with Zero Fare**
SELECT COUNT(*) 
FROM `zoomcamp.yellow_trip_data_regular` 
WHERE fare_amount = 0.0;
***
**Q5. Partitioning and Clustering**
CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_optimized`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS
SELECT *
FROM `zoomcamp.yellow_trip_records`;
Answer:
Partitioning by tpep_dropoff_datetime and clustering by VendorID reduces query cost and improves performance.
***
**Q6. Query Cost with Optimization**
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
Optimized table: 26.84 MB scanned.
***
**Q7. Data Source**
Answer:
Data is stored in a Google Cloud Storage bucket (gs://yellow_taxi_trip_records_parquet/).
***
**Q8. True/False**
Statement: “Materialized tables are always cheaper.”
Answer: False.
Materialized tables are often faster and cheaper, but not always. Query cost depends on partitioning, clustering, and query type.
Q9. COUNT(*) Query
SELECT COUNT(*) FROM `zoomcamp.yellow_trip_data_regular`;
Answer:
Estimated bytes processed = near zero.
BigQuery answers COUNT(*) using row metadata, not by scanning all columns.
