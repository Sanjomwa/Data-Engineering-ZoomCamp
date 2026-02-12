{% macro set_duckdb_limits() %}
  {% do run_query("SET memory_limit = '3GB';") %}    -- adjust 2GB–4GB depending on your Codespace size
  {% do run_query("SET threads = '2';") %}           -- usually 1–4 is plenty
  {% do run_query("SET enable_progress_bar = true;") %}  -- nice to see progress
{% endmacro %}