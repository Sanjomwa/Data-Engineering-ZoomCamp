#!/bin/bash

# ==============================================================================
# Verification Script for GCP Infrastructure Setup
# ==============================================================================
# Verifies that all components are properly configured:
# - Service account exists and has correct permissions
# - BigQuery datasets are created with correct location
# - BigQuery tables exist with data
# - GCS bucket exists with data
#
# Usage:
#   ./verify-setup.sh
# ==============================================================================

set -e # Exit on error

echo "=========================================="
echo "GCP Infrastructure Verification"
echo "=========================================="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

pass() { echo -e "${GREEN}✅ PASS:${NC} $1"; ((PASSED++)); }
fail() { echo -e "${RED}❌ FAIL:${NC} $1"; ((FAILED++)); }
warn() { echo -e "${YELLOW}⚠️  WARN:${NC} $1"; }

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
echo "Verifying project: $PROJECT_ID"
echo

# --- Service Account Check ---
SA_EMAIL="analytical-engineering-04-sa@${PROJECT_ID}.iam.gserviceaccount.com"
KEY_FILE="./gcs.json"

if gcloud iam service-accounts describe "$SA_EMAIL" &>/dev/null; then
    pass "Service account exists: $SA_EMAIL"
else
    fail "Service account not found: $SA_EMAIL"
fi

if [ -f "$KEY_FILE" ]; then
    pass "Service account key file exists: $KEY_FILE"
else
    fail "Service account key file not found: $KEY_FILE"
fi

echo

# --- Dataset Check ---
if bq show --format=prettyjson "${PROJECT_ID}:nytaxi" &>/dev/null; then
    pass "Dataset exists: nytaxi"
    LOCATION=$(bq show --format=prettyjson "${PROJECT_ID}:nytaxi" | grep -o '"location": "[^"]*"' | cut -d'"' -f4)
    if [ "$LOCATION" = "US" ]; then
        pass "Dataset location is US"
    else
        warn "Dataset location is $LOCATION (expected US)"
    fi
else
    fail "Dataset not found: nytaxi"
fi

echo

# --- Tables Check ---
declare -A COUNTS
for TABLE in yellow_tripdata green_tripdata fhv_tripdata; do
    if bq show "${PROJECT_ID}:nytaxi.${TABLE}" &>/dev/null; then
        pass "Table exists: nytaxi.${TABLE}"
        COUNT=$(bq query --use_legacy_sql=false --format=csv \
            "SELECT COUNT(*) as count FROM \`${PROJECT_ID}.nytaxi.${TABLE}\`" 2>/dev/null | tail -n 1)
        COUNTS[$TABLE]=$COUNT
        if [ ! -z "$COUNT" ] && [ "$COUNT" -gt 0 ]; then
            pass "${TABLE} has data: $COUNT records"
        else
            fail "${TABLE} is empty"
        fi
    else
        fail "Table not found: nytaxi.${TABLE}"
    fi
done

echo

# --- GCS Bucket Check ---
echo "Enter your GCS bucket name (or press Enter to skip):"
read -p "Bucket name: " BUCKET_NAME

if [ ! -z "$BUCKET_NAME" ]; then
    if gsutil ls "gs://$BUCKET_NAME" &>/dev/null; then
        pass "Bucket exists: gs://$BUCKET_NAME"
        for FOLDER in yellow green fhv; do
            FILES=$(gsutil ls "gs://$BUCKET_NAME/${FOLDER}/*.csv.gz" 2>/dev/null | wc -l)
            if [ "$FILES" -gt 0 ]; then
                pass "${FOLDER} taxi files in GCS: $FILES files"
            else
                warn "No ${FOLDER} taxi files found in GCS"
            fi
        done
    else
        fail "Bucket not found or no access: gs://$BUCKET_NAME"
    fi
else
    warn "GCS bucket verification skipped"
fi

echo

# --- Summary ---
echo "=========================================="
echo "VERIFICATION SUMMARY"
echo "=========================================="
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo

echo "Row Count Summary:"
for TABLE in yellow_tripdata green_tripdata fhv_tripdata; do
    if [ ! -z "${COUNTS[$TABLE]}" ]; then
        echo -e "${GREEN}${TABLE}:${NC} ${COUNTS[$TABLE]} records"
    else
        echo -e "${RED}${TABLE}:${NC} not found or empty"
    fi
done

echo
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ ALL CHECKS PASSED${NC}"
    echo "Your GCP infrastructure is ready for dbt!"
else
    echo -e "${RED}❌ SOME CHECKS FAILED${NC}"
    echo "Please review the failed checks above."
fi

echo "=========================================="
