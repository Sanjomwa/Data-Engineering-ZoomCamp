CREATE EXTERNAL TABLE `zoomcamp.yellow_trip_records`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://yellow_taxi_trip_records_parquet/*.parquet']
);   



CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_regular` AS
SELECT *
FROM `zoomcamp.yellow_trip_records`;

-- Q1 20332093
SELECT * FROM `zoomcamp.yellow_trip_records`; 
SELECT * FROM `zoomcamp.yellow_trip_data_regular`;


-- Q2
-- 0 MB for the External Table and 155.12 MB for the Materialized Table
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_records`;
SELECT DISTINCT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;


-- Q3
-- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.
SELECT PULocationID FROM `zoomcamp.yellow_trip_data_regular`;
SELECT PULocationID, DOLocationID FROM `zoomcamp.yellow_trip_data_regular`;

--Q4
-- 8333
SELECT COUNT(*) FROM `zoomcamp.yellow_trip_data_regular` WHERE fare_amount=0.0;

--Q5
-- Partition by tpep_dropoff_datetime and Cluster on VendorID
CREATE OR REPLACE TABLE `zoomcamp.yellow_trip_data_optimized`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS
SELECT *
FROM `zoomcamp.yellow_trip_records`;

--Q6
--1. 310.24 MB when run.
SELECT DISTINCT VendorID FROM `zoomcamp.yellow_trip_data_regular` 
WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' AND DATE(tpep_dropoff_datetime) <= '2024-03-15';

-- 2. 26.84 MB when run.
SELECT DISTINCT VendorID FROM `zoomcamp.yellow_trip_data_optimized`
WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' AND DATE(tpep_dropoff_datetime) <= '2024-03-15';

-- Q7
-- GCP Bucket

--Q8
-- False

-- Q10
SELECT COUNT(*) FROM `zoomcamp.yellow_trip_data_regular`