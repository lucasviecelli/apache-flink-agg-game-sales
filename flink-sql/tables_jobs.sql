
CREATE TABLE game_sales (
    id STRING,
    game_name STRING,
    platform STRING,
    date_sale TIMESTAMP(3),
    country STRING,
    genre STRING,
    publisher STRING,
    price DOUBLE,
    proctime AS PROCTIME(),
    WATERMARK FOR date_sale AS date_sale - INTERVAL '5' SECOND
) PARTITIONED BY (`platform`)
WITH (
    'connector' = 'kafka',
    'topic' = 'game-sales',
    'scan.startup.mode' = 'earliest-offset',
    'properties.bootstrap.servers' = 'broker:29092',
    'format' = 'json',
    'json.ignore-parse-errors' = 'true'
);

-- top_hit_platforms

CREATE TABLE top_hit_platforms (
    platform_name STRING ,
    platform_count BIGINT,
    CONSTRAINT top_hit_platforms_pk PRIMARY KEY (platform_name) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/flink',
    'table-name' = 'top_hit_platforms',
    'username' = 'postgres',
    'password' = '123456',
    'driver' = 'org.postgresql.Driver',
    'scan.fetch-size' = '100',
    'sink.buffer-flush.max-rows' = '5000',
    'sink.buffer-flush.interval' = '30s'
);

-- top_hit_games

CREATE TABLE top_hit_games (
    game_name STRING ,
    platform_name STRING,
    game_count BIGINT,
    CONSTRAINT top_hit_games_pk PRIMARY KEY (game_name, platform_name) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/flink',
    'table-name' = 'top_hit_games',
    'username' = 'postgres',
    'password' = '123456',
    'driver' = 'org.postgresql.Driver',
    'scan.fetch-size' = '100',
    'sink.buffer-flush.max-rows' = '5000',
    'sink.buffer-flush.interval' = '30s'
);

INSERT INTO top_hit_platforms
SELECT platform, COUNT(*) platform_count
FROM game_sales
GROUP BY platform;

INSERT INTO top_hit_games
SELECT game_name, platform, COUNT(*) game_count
FROM game_sales
GROUP BY game_name, platform;