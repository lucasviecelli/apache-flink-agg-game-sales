
CREATE TABLE top_hit_platforms (
    platform_name TEXT PRIMARY KEY,
    platform_count BIGINT
);

CREATE TABLE top_hit_games (
    game_name TEXT,
    platform_name TEXT,
    game_count BIGINT,
    CONSTRAINT top_hit_games_pk  PRIMARY KEY (game_name, platform_name)
);