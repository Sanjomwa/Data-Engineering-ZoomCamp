import pandas as pd
from sqlalchemy import create_engine, text


def read_data():
    """
    Reads parquet and CSV files mounted via docker-compose volumes.
    Paths must match the volume mapping in docker-compose.yaml.
    """

    # Green taxi trip data
    green_trip_df = pd.read_parquet("/temp_app/data/green_tripdata_2025-11.parquet")
    green_trip_df.columns = [c.lower() for c in green_trip_df.columns]

    # Taxi zone lookup data
    taxi_zone_df = pd.read_csv("/temp_app/data/taxi_zone_lookup.csv")
    taxi_zone_df.columns = [c.lower() for c in taxi_zone_df.columns]

    return {
        "green_trip_data": green_trip_df,
        "taxi_zone_lookup_data": taxi_zone_df
    }


def conn_to_db():
    """
    Creates a SQLAlchemy engine to connect to Postgres running in docker-compose.
    Matches POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, and service name.
    """

    user = "root"
    password = "root"
    db_name = "postgres_ny_taxi"   # matches POSTGRES_DB in docker-compose
    host = "postgres-ny-taxi"      # service name in docker-compose
    port = 5432

    url = f"postgresql://{user}:{password}@{host}:{port}/{db_name}"

    try:
        engine = create_engine(url)
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        print("✅ Connected to Postgres")
        return engine
    except Exception as e:
        print(f"❌ Error connecting to Postgres: {e}")
        return None


def load_data(df, table_name, engine):
    """
    Loads a DataFrame into Postgres as a table.
    """
    if engine is not None:
        try:
            df.to_sql(name=table_name, con=engine, index=False, if_exists="replace")
            print(f"✅ Loaded {len(df)} rows into table: {table_name}")
        except Exception as e:
            print(f"❌ Error loading data into table {table_name}: {e}")


if __name__ == "__main__":
    data = read_data()
    engine = conn_to_db()

    load_data(df=data["green_trip_data"], table_name="green_trip", engine=engine)
    load_data(df=data["taxi_zone_lookup_data"], table_name="taxi_zone_lookup", engine=engine)
