CREATE EXTERNAL TABLE `encoded-joy-485413-k5.nyc_taxi.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://njogu-dezoomcamp_hw3_2026/yellow_tripdata_2024-*.parquet']
);



CREATE OR REPLACE TABLE `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular` AS
SELECT *
FROM `encoded-joy-485413-k5.nyc_taxi.external_yellow_tripdata`;


-- Q1 20332093
-- External table
SELECT * FROM `encoded-joy-485413-k5.nyc_taxi.external_yellow_tripdata`;

-- Materialized table
SELECT * FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular`;


-- Q2
-- 0 MB for the External Table and 155.12 MB for the Materialized Table
-- Compare distinct values
SELECT DISTINCT PULocationID FROM `encoded-joy-485413-k5.nyc_taxi.external_yellow_tripdata`;
SELECT DISTINCT PULocationID FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular`;



-- Q3
-- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.
-- Columnar scan comparison
SELECT PULocationID FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular`;
SELECT PULocationID, DOLocationID FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular`;


--Q4
-- 8333
SELECT COUNT(*) 
FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular` 
WHERE fare_amount = 0.0;


--Q5
-- Partition by tpep_dropoff_datetime and Cluster on VendorID
CREATE OR REPLACE TABLE `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_optimized`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT *
FROM `encoded-joy-485413-k5.nyc_taxi.external_yellow_tripdata`;


--Q6
-- 1. Regular table
-- 310.24 MB for non-partitioned table
SELECT DISTINCT VendorID 
FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- 2. Optimized table
-- 26.84 MB for the partitioned table
SELECT DISTINCT VendorID 
FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_optimized`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';


-- Q7
-- GCP Bucket

--Q8
-- False

-- Q9
SELECT COUNT(*) 
FROM `encoded-joy-485413-k5.nyc_taxi.yellow_trip_data_regular`;
