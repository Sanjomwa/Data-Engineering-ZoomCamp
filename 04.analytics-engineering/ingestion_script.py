import duckdb
import requests
from pathlib import Path

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

def download_and_convert_files(taxi_type, years):
    data_dir = Path("data") / taxi_type
    data_dir.mkdir(exist_ok=True, parents=True)

    for year in years:
        for month in range(1, 13):
            parquet_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.parquet"
            parquet_filepath = data_dir / parquet_filename

            if parquet_filepath.exists():
                print(f"Skipping {parquet_filename} (already exists)")
                continue

            # Download CSV.gz file
            csv_gz_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
            csv_gz_filepath = data_dir / csv_gz_filename

            print(f"Downloading {csv_gz_filename}...")
            response = requests.get(f"{BASE_URL}/{taxi_type}/{csv_gz_filename}", stream=True)
            if response.status_code != 200:
                print(f"Warning: {csv_gz_filename} not found, skipping")
                continue

            with open(csv_gz_filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Converting {csv_gz_filename} to Parquet...")
            con = duckdb.connect()
            con.execute(f"""
                COPY (SELECT * FROM read_csv_auto('{csv_gz_filepath}'))
                TO '{parquet_filepath}' (FORMAT PARQUET)
            """)
            con.close()

            # Remove the CSV.gz file to save space
            if csv_gz_filepath.exists():
                csv_gz_filepath.unlink()
            else:
                print(f"Warning: {csv_gz_filepath} not found, skipping unlink")

            print(f"Completed {parquet_filename}")

def update_gitignore():
    gitignore_path = Path(".gitignore")
    content = gitignore_path.read_text() if gitignore_path.exists() else ""
    if 'data/' not in content:
        with open(gitignore_path, 'a') as f:
            f.write('\n# Data directory\ndata/\n' if content else '# Data directory\ndata/\n')

if __name__ == "__main__":
    update_gitignore()

    # Yellow + Green (2019–2020)
    for taxi_type in ["yellow", "green"]:
        download_and_convert_files(taxi_type, years=[2019, 2020])

    # FHV (2019 only)
    download_and_convert_files("fhv", years=[2019])

    # Create DuckDB tables
    con = duckdb.connect("taxi_rides_ny.duckdb")
    con.execute("CREATE SCHEMA IF NOT EXISTS prod")

    for taxi_type in ["yellow", "green", "fhv"]:
        con.execute(f"""
            CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
            SELECT * FROM read_parquet('data/{taxi_type}/*.parquet', union_by_name=true)
        """)

    con.close()
    print("Data ingestion and conversion completed successfully") 