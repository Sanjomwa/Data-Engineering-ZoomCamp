import duckdb

con = duckdb.connect('/workspaces/Data-Engineering-ZoomCamp/04.analytics-engineering/taxi_rides_ny.duckdb')
con.execute("CREATE SCHEMA IF NOT EXISTS prod")

for taxi_type in ["yellow", "green"]:
    con.execute(f"""
        CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
        SELECT * FROM read_parquet('data/{taxi_type}/*.parquet', union_by_name=true)
    """)
    count = con.execute(f"SELECT COUNT(*) FROM prod.{taxi_type}_tripdata").fetchone()[0]
    print(f"✅ Created prod.{taxi_type}_tripdata with {count} rows")

con.close()
