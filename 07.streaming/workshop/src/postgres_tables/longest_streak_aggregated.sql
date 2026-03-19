CREATE TABLE IF NOT EXISTS longest_streak_aggregated (
    window_start TIMESTAMP(3),
    window_end   TIMESTAMP(3),
    PULocationID INT,
    num_trips    BIGINT,
    PRIMARY KEY (window_start, window_end, PULocationID)
);