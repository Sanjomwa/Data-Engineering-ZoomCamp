import duckdb

con = duckdb.connect('/workspaces/Data-Engineering-ZoomCamp/04.analytics-engineering/taxi_rides_ny/taxi_rides_ny.duckdb')

# List all schemas
print("Schemas:", con.execute("SELECT schema_name FROM information_schema.schemata").fetchall())

# List tables in prod schema
print("Tables in prod:", con.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='prod'").fetchall())

# Row counts
print("Yellow rows:", con.execute("SELECT COUNT(*) FROM prod.yellow_tripdata").fetchall())
print("Green rows:", con.execute("SELECT COUNT(*) FROM prod.green_tripdata").fetchall())

# Preview data
print("Yellow sample:", con.execute("SELECT * FROM prod.yellow_tripdata LIMIT 5").fetchall())
print("Green sample:", con.execute("SELECT * FROM prod.green_tripdata LIMIT 5").fetchall())
