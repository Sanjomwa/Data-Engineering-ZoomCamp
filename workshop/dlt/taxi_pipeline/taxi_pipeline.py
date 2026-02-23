"""Pipeline to ingest NYC Taxi data from REST API using dlt."""

import dlt
from dlt.sources.rest_api import rest_api_resources
from dlt.sources.rest_api.typing import RESTAPIConfig


@dlt.source
def taxi_pipeline_rest_api_source(access_token: str = dlt.secrets.value):
    """Define dlt resources from REST API endpoints."""
    config: RESTAPIConfig = {
        "client": {
            # Base URL for the NYC Taxi API
            "base_url": "https://us-central1-dlthub-analytics.cloudfunctions.net/data_engineering_zoomcamp_api",
            # No authentication required for this API, so remove auth if not needed
        },
        "resources": [
            {
                "name": "taxi_rides",
                "endpoint": "/taxi",
                "params": {
                    "page": 1  # pagination starts at page=1
                },
                "pagination": {
                    "type": "page",
                    "parameter": "page",
                    "stop_condition": "empty"  # stop when an empty page is returned
                },
            }
        ],
        # Apply defaults to all resources if needed
        "resource_defaults": {
            "write_disposition": "replace"  # overwrite on each run
        },
    }

    yield from rest_api_resources(config)


pipeline = dlt.pipeline(
    pipeline_name="taxi_pipeline_pipeline",
    destination="duckdb",
    refresh="drop_sources",  # reset state on each run
    progress="log",
)


if __name__ == "__main__":
    load_info = pipeline.run(taxi_pipeline_rest_api_source())
    print(load_info)
