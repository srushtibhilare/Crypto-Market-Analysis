SELECT *
FROM crypto_data
LIMIT 10;
SELECT COUNT(*) AS total_rows
FROM crypto_data;
SELECT *
FROM crypto_data
WHERE timestamp BETWEEN '2022-01-01' AND '2022-12-31';
SELECT *
FROM crypto_data
WHERE volume > (
    SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (
        ORDER BY volume
      )
    FROM crypto_data
  );
SELECT *
FROM crypto_data
WHERE close < open;
SELECT AVG(close) AS avg_close_price
FROM crypto_data;
SELECT MAX(high) AS highest_price,
  MIN(low) AS lowest_price
FROM crypto_data;
SELECT SUM(volume) AS total_volume
FROM crypto_data;
SELECT DATE(timestamp) AS day,
  AVG(close) AS avg_close
FROM crypto_data
GROUP BY day
ORDER BY day;
SELECT DATE_TRUNC('month', timestamp) AS month,
  AVG(close) AS avg_close
FROM crypto_data
GROUP BY DATE_TRUNC('month', timestamp)
ORDER BY month;
SELECT DATE_TRUNC('year', timestamp) AS year,
  AVG(close) AS avg_close
FROM crypto_data
GROUP BY year
ORDER BY year;
SELECT WIDTH_BUCKET(
    close,
    (
      SELECT MIN(close)
      FROM crypto_data
    ),
    (
      SELECT MAX(close)
      FROM crypto_data
    ),
    10
  ) AS price_bucket,
  COUNT(*) AS frequency
FROM crypto_data
GROUP BY price_bucket
ORDER BY price_bucket;
SELECT EXTRACT(
    QUARTER
    FROM timestamp
  ) AS quarter,
  SUM(volume) AS total_volume
FROM crypto_data
GROUP BY EXTRACT(
    QUARTER
    FROM timestamp
  )
ORDER BY quarter;
SELECT DATE_TRUNC('month', timestamp) AS month,
  AVG(volume) AS avg_volume
FROM crypto_data
GROUP BY DATE_TRUNC('month', timestamp)
ORDER BY month;
SELECT DATE(timestamp) AS day,
  AVG(high - low) AS daily_volatility
FROM crypto_data
GROUP BY day
ORDER BY day;
SELECT timestamp,
  (high - low) AS volatility
FROM crypto_data
ORDER BY volatility DESC
LIMIT 5;
SELECT *
FROM crypto_data
WHERE high < GREATEST(open, close, low)
  OR low > LEAST(open, close, high);
SELECT CORR(close, volume) AS price_volume_correlation
FROM crypto_data;
SELECT COUNT(*) AS total_rows,
  COUNT(timestamp) AS non_null_timestamp
FROM crypto_data;
SELECT timestamp
FROM crypto_data
WHERE timestamp IS NULL
  OR timestamp::text !~ '^\d{4}-\d{2}-\d{2}';
CREATE OR REPLACE VIEW crypto_data_clean AS
SELECT timestamp::timestamp AS timestamp,
  open,
  high,
  low,
  close,
  volume
FROM crypto_data
WHERE timestamp IS NOT NULL;