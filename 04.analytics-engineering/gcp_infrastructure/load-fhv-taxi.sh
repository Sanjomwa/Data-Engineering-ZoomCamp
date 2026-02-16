#!/bin/bash
set -e

PROJECT_ID="analytical-engineering-04"
DATASET="nytaxi"
TABLE="fhv_tripdata"
EXTERNAL_TABLE="external_fhv_tripdata"
YEAR="2019"
BASE_URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv"

echo "======================================"
echo "Loading FHV Taxi Data into BigQuery"
echo "======================================"
echo "Project: $PROJECT_ID"
echo "Dataset: $DATASET"
echo "Table: $TABLE"
echo "Year: $YEAR"
echo ""

echo "Enter your GCS bucket name (from Terraform output):"
read -p "Bucket name: " BUCKET_NAME

mkdir -p fhv_data
cd fhv_data

# Download 2019 files
for MONTH in {01..12}; do
  FILE="fhv_tripdata_${YEAR}-${MONTH}.csv.gz"
  URL="${BASE_URL}/${FILE}"
  echo "Downloading: $FILE"
  if curl -f -L -o "$FILE" "$URL"; then
    echo "✅ Downloaded: $FILE"
  else
    echo "⚠️  Warning: Could not download $FILE"
  fi
done

echo "Uploading to GCS..."
gsutil -m cp fhv_tripdata_*.csv.gz "gs://$BUCKET_NAME/fhv/"
echo "✅ Upload complete"

# Create external table
bq query --use_legacy_sql=false "
CREATE OR REPLACE EXTERNAL TABLE \`${PROJECT_ID}.${DATASET}.${EXTERNAL_TABLE}\`
OPTIONS (
  format = 'CSV',
  compression = 'GZIP',
  uris = ['gs://${BUCKET_NAME}/fhv/*.csv.gz'],
  skip_leading_rows = 1
);
"

# Create materialized table
bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE \`${PROJECT_ID}.${DATASET}.${TABLE}\`
AS SELECT * FROM \`${PROJECT_ID}.${DATASET}.${EXTERNAL_TABLE}\`;
"

# Verify
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`${PROJECT_ID}.${DATASET}.${TABLE}\`"
echo "FHV Taxi data loaded successfully into BigQuery!"
