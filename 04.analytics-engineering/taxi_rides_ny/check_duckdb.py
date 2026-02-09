import duckdb

# Connect to the parent-folder DuckDB file (the big one with data)
con = duckdb.connect('/workspaces/Data-Engineering-ZoomCamp/04.analytics-engineering/taxi_rides_ny.duckdb')

tables = con.execute("""
    SELECT table_schema, table_name
    FROM information_schema.tables
    WHERE table_type='BASE TABLE'
""").fetchall()

print("Tables found:", tables)

for schema, table in tables:
    full_name = f"{schema}.{table}"
    print(f"\n=== {full_name} ===")
    count = con.execute(f"SELECT COUNT(*) FROM {full_name}").fetchone()[0]
    print(f"Row count: {count}")
    sample = con.execute(f"SELECT * FROM {full_name} LIMIT 5").fetchall()
    print("Sample rows:", sample)
