# dlt Workshop Homework

## Question 1: What is the time range of the dataset?
Query:
```sql
SELECT
    MIN(trip_pickup_date_time) AS earliest_pickup,
    MAX(trip_pickup_date_time) AS latest_pickup,
    MIN(trip_dropoff_date_time) AS earliest_dropoff,
    MAX(trip_dropoff_date_time) AS latest_dropoff
FROM taxi_data_20260223045641.rides;
```
<img width="1228" height="332" alt="Screenshot 2026-02-23 201148" src="https://github.com/user-attachments/assets/baa43559-8614-406b-8898-5a09d0096d12" />
## ANSWER: 2009-06-01 to 2009-07-01

## Question 2: What is the total amount of tips?
```sql
SELECT SUM(tip_amt)
FROM taxi_data_20260223045641.rides;
```
<img width="1064" height="294" alt="Screenshot 2026-02-23 201332" src="https://github.com/user-attachments/assets/ed3db51c-b25d-4317-ae65-6e5008ff8815" />
## ANSWER: 26.66%

## Question 3: What proportion of rides were paid with credit?
```sql
SELECT
    SUM(CASE WHEN payment_type = 'Credit' THEN 1 ELSE 0 END) AS credit_rides,
    COUNT(*) AS all_rides,
    SUM(CASE WHEN payment_type = 'Credit' THEN 1 ELSE 0 END) / COUNT(*) AS credit_proportion
FROM taxi_data_20260223045641.rides;
```
<img width="454" height="241" alt="Screenshot 2026-02-23 201521" src="https://github.com/user-attachments/assets/002d0daf-423e-41e4-ae86-128ab8a6d3d2" />
## ANSWER: $6,063.41

## Reflection on Pipeline Investigation Methods

After running my `taxi_pipeline` successfully, I explored the dataset using DuckDB queries.  
I was able to confirm ingestion of 10,000 rows and inspect the `rides` table with queries like:

- `SELECT COUNT(*) FROM taxi_data_20260223045641.rides;`
- `SELECT DISTINCT payment_type FROM taxi_data_20260223045641.rides;`
- `SELECT MIN(trip_pickup_date_time), MAX(trip_dropoff_date_time) FROM taxi_data_20260223045641.rides;`

### dlt Dashboard
I relied on the pipeline logs and `.tables` output in DuckDB to confirm that `rides` and metadata tables (`_dlt_loads`, `_dlt_pipeline_state`) were created.  
The dashboard would provide a more visual way to inspect load packages and schema evolution, but the logs were enough for validation.

### dlt MCP Server
I haven't used the MCP server directly yet. Instead, I asked questions of the data by writing SQL queries.  
MCP could have streamlined this by answering pipeline questions without SQL, but I found direct queries straightforward.

### Marimo Notebook
I haven't opened Marimo in this run yet. I will use it to visualize trip counts per day, fare distributions, and payment type breakdowns.  
For now, I focused on SQL queries in DuckDB to validate ingestion.

### What Worked Best
For me, DuckDB queries were the most effective way to validate the pipeline quickly.  
The dashboard and MCP server could add convenience, and Marimo would be useful for visualizations, but SQL gave me direct control and clear answers.
Overall, I feel confident that the pipeline ingested the data correctly, and I have a good starting point for further analysis and visualization.
