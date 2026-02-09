import duckdb

# Connect to DuckDB (creates file if not exists)
con = duckdb.connect("04.analytics-engineering/taxi_rides_ny.duckdb")

# Create schema
con.execute("CREATE SCHEMA IF NOT EXISTS prod;")

# Function to ingest parquet files into DuckDB
def ingest_taxi_data(service: str, years: list, months: list = None):
    for year in years:
        if months is None:  # ingest all months
            pattern = f"data/{service}_tripdata_{year}-*.parquet"
        else:  # ingest specific months
            pattern = " ".join(
                [f"data/{service}_tripdata_{year}-{month:02d}.parquet" for month in months]
            )
        table_name = f"prod.{service}_tripdata"
        con.execute(f"""
            CREATE OR REPLACE TABLE {table_name} AS
            SELECT * FROM read_parquet('{pattern}', hive_partitioning = true);
        """)

# Ingest Yellow taxi (2019 + 2020, all months)
ingest_taxi_data("yellow", years=[2019, 2020])

# Ingest Green taxi (Oct 2019 + all of 2020)
ingest_taxi_data("green", years=[2019], months=[10])
ingest_taxi_data("green", years=[2020])

# Close connection
con.close()
