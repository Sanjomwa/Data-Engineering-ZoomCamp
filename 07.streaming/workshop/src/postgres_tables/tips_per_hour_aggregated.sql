CREATE TABLE IF NOT EXISTS tips_per_hour_aggregated (
    window_start TIMESTAMP(3),
    total_tips   DOUBLE PRECISION,
    PRIMARY KEY (window_start)
);