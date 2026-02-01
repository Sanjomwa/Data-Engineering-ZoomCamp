import os
import pandas as pd
from sqlalchemy import create_engine, text


def read_data():
    """
    Reads parquet and CSV files mounted via docker-compose volumes.
    Adds logging to confirm file existence before reading.
    """
    base_path = "/temp_app/data"
    parquet_file = os.path.join(base_path, "green_tripdata_2025-11.parquet")
    csv_file = os.path.join(base_path, "taxi_zone_lookup.csv")

    print(f"🔎 Looking for parquet file at: {parquet_file}")
    print(f"🔎 Looking for CSV file at: {csv_file}")

    if not os.path.exists(parquet_file):
        raise FileNotFoundError(f"❌ Parquet file not found: {parquet_file}")
    if not os.path.exists(csv_file):
        raise FileNotFoundError(f"❌ CSV file not found: {csv_file}")

    green_trip_df = pd.read_parquet(parquet_file)
    green_trip_df.columns = [c.lower() for c in green_trip_df.columns]
    print(f"✅ Loaded parquet file with {len(green_trip_df)} rows")

    taxi_zone_df = pd.read_csv(csv_file)
    taxi_zone_df.columns = [c.lower() for c in taxi_zone_df.columns]
    print(f"✅ Loaded CSV file with {len(taxi_zone_df)} rows")

    return {
        "green_trip_data": green_trip_df,
        "taxi_zone_lookup_data": taxi_zone_df
    }


def conn_to_db():
    """
    Creates a SQLAlchemy engine to connect to Postgres running in docker-compose.
    Logs the connection string for debugging.
    """
    user = "root"
    password = "root"
    db_name = "postgres_ny_taxi"   # matches POSTGRES_DB in docker-compose
    host = "postgres-ny-taxi"      # matches service name in docker-compose
    port = 5432

    url = f"postgresql://{user}:{password}@{host}:{port}/{db_name}"
    print(f"🔎 Attempting DB connection with URL: {url}")

    try:
        engine = create_engine(url)
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        print("✅ Connected to Postgres successfully")
        return engine
    except Exception as e:
        print(f"❌ Error connecting to Postgres: {e}")
        return None


def load_data(df, table_name, engine):
    """
    Loads a DataFrame into Postgres as a table.
    Adds logging for row counts and errors.
    """
    if engine is not None:
        try:
            print(f"🔎 Loading {len(df)} rows into table: {table_name}")
            df.to_sql(name=table_name, con=engine, index=False, if_exists="replace")
            print(f"✅ Successfully loaded {len(df)} rows into table: {table_name}")
        except Exception as e:
            print(f"❌ Error loading data into table {table_name}: {e}")
    else:
        print("❌ No valid DB engine, skipping load")


if __name__ == "__main__":
    try:
        data = read_data()
        engine = conn_to_db()

        load_data(df=data["green_trip_data"], table_name="green_trip", engine=engine)
        load_data(df=data["taxi_zone_lookup_data"], table_name="taxi_zone_lookup", engine=engine)
    except Exception as e:
        print(f"❌ Pipeline failed: {e}")
