import pandas as pd
from sqlalchemy import create_engine


def read_data():
    """
    Reads local parquet and CSV files mounted via docker-compose volumes.
    Adjust paths if you change volume mounts in docker-compose.yml.
    """

    # Green taxi trip data (parquet)
    green_trip_df = pd.read_parquet("/temp_app/data/green_tripdata_2025-11.parquet")
    green_trip_df.columns = [c.lower() for c in green_trip_df.columns]

    # Taxi zone lookup data (csv)
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
    engine = create_engine(url)
    return engine


def ingest():
    """
    Reads data and writes to Postgres tables.
    """

    dfs = read_data()
    engine = conn_to_db()

    # Write green taxi data
    dfs["green_trip_data"].to_sql(
        "green_trip_data",
        con=engine,
        if_exists="replace",
        index=False
    )

    # Write taxi zone lookup data
    dfs["taxi_zone_lookup_data"].to_sql(
        "taxi_zone_lookup",
        con=engine,
        if_exists="replace",
        index=False
    )

    print("✅ Data successfully ingested into Postgres!")


if __name__ == "__main__":
    ingest()
