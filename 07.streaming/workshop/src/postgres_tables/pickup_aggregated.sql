CREATE TABLE IF NOT EXISTS pickup_aggregated (
    window_start TIMESTAMP(3),
    PULocationID INT,
    num_trips BIGINT,
    PRIMARY KEY (window_start, PULocationID)
);