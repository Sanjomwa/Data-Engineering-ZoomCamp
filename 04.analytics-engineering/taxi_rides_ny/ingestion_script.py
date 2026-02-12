import duckdb
import requests
from pathlib import Path

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

# All paths are relative to the taxi_rides_ny folder (where the script lives)
PROJECT_DIR = Path(__file__).parent.resolve()           # /.../taxi_rides_ny
DATA_ROOT   = PROJECT_DIR / "data"                      # /.../taxi_rides_ny/data
DB_PATH     = PROJECT_DIR / "taxi_rides_ny.duckdb"

DATA_ROOT.mkdir(parents=True, exist_ok=True)

def download_and_convert_files(taxi_type: str):
    data_dir = DATA_ROOT / taxi_type
    data_dir.mkdir(parents=True, exist_ok=True)

    for year in [2019, 2020]:
        for month in range(1, 13):
            parquet_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.parquet"
            parquet_filepath = data_dir / parquet_filename

            if parquet_filepath.exists():
                print(f"Skipping {parquet_filename} (already exists)")
                continue

            # Download CSV.gz
            csv_gz_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
            csv_gz_filepath = data_dir / csv_gz_filename

            url = f"{BASE_URL}/{taxi_type}/{csv_gz_filename}"
            print(f"Downloading {csv_gz_filename} ...")
            response = requests.get(url, stream=True)
            response.raise_for_status()

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

            # Clean up csv.gz
            csv_gz_filepath.unlink(missing_ok=True)
            print(f"Completed {parquet_filename}\n")

def update_gitignore():
    gitignore_path = PROJECT_DIR / ".gitignore"
    content = gitignore_path.read_text() if gitignore_path.exists() else ""

    if 'data/' not in content:
        with open(gitignore_path, 'a') as f:
            if content and not content.endswith('\n'):
                f.write('\n')
            f.write('# Data directory\ndata/\n')

if __name__ == "__main__":
    print("Starting NYC Taxi data ingestion...\n")
    update_gitignore()

    for taxi_type in ["yellow", "green"]:
        download_and_convert_files(taxi_type)

    print("All downloads & conversions finished. Now loading into DuckDB...\n")

    con = duckdb.connect(DB_PATH)
    con.execute("CREATE SCHEMA IF NOT EXISTS prod")

    for taxi_type in ["yellow", "green"]:
        pattern = f"data/{taxi_type}/*.parquet"
        print(f"Creating table prod.{taxi_type}_tripdata from: {pattern}")

        con.execute(f"""
            CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
            SELECT * FROM read_parquet('{pattern}', union_by_name=true)
        """)

    con.close()
    print(f"Done! DuckDB database created at: {DB_PATH}")