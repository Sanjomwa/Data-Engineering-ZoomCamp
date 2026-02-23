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
I didn’t use the MCP server directly. Instead, I asked questions of the data by writing SQL queries.  
MCP could have streamlined this by answering pipeline questions without SQL, but I found direct queries straightforward.

### Marimo Notebook
I didn’t open Marimo in this run. If I had, I would use it to visualize trip counts per day, fare distributions, and payment type breakdowns.  
For now, I focused on SQL queries in DuckDB to validate ingestion.

### What Worked Best
For me, DuckDB queries were the most effective way to validate the pipeline quickly.  
The dashboard and MCP server could add convenience, and Marimo would be useful for visualizations, but SQL gave me direct control and clear answers.
Overall, I feel confident that the pipeline ingested the data correctly, and I have a good starting point for further analysis and visualization.