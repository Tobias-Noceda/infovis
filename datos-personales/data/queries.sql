-- Queries para graficos:
-- RawGraphs
WITH 
  genres_totals AS (
    SELECT a.genre, a.genre_group, (SUM(m.msplayed) / 60000.0) as total_minutes_played
    FROM mi_musica_total m
      JOIN mis_artistas_total a ON m.artistName = a.artistName
    WHERE a.genre IS NOT NULL
    group by a.genre, a.genre_group
  ),
  genre_group_ranking AS (
    SELECT 
      ROW_NUMBER() OVER (PARTITION BY genre_group ORDER BY total_minutes_played DESC) as ranking,
      genre, 
      genre_group, 
      total_minutes_played
    FROM genres_totals
  )
SELECT genre, genre_group, total_minutes_played
FROM genre_group_ranking
WHERE ranking <= 3

UNION ALL

SELECT 'Other' as genre, genre_group, SUM(total_minutes_played) as total_minutes_played
FROM genre_group_ranking
WHERE ranking > 3
GROUP BY genre_group
HAVING SUM(total_minutes_played) > 0;

-- Flourish
SELECT a.genre_group, a.artistname, (SUM(m.msplayed) / 60000.0) as total_minutes_played
FROM mi_musica_total m
  JOIN mis_artistas_total a ON m.artistName = a.artistName
WHERE a.genre IS NOT NULL
group by a.genre_group, a.artistname
ORDER BY a.genre_group, total_minutes_played DESC;

-- Genres:
CREATE TABLE spotify_total_by_year_genre AS
SELECT
    date_trunc('year', m.starttime_arg)::date AS year,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Rock') / 60000.0, 0) AS rock,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Pop') / 60000.0, 0) AS pop,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Indie') / 60000.0, 0) AS indie,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Ska/Reggae') / 60000.0, 0) AS ska_reggae,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Latin') / 60000.0, 0) AS latin,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Hip-Hop') / 60000.0, 0) AS hip_hop,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Electronic') / 60000.0, 0) AS electronic,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Folk') / 60000.0, 0) AS folk,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Soul/R&B/Blues') / 60000.0, 0) AS soul_rnb_blues,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Christian') / 60000.0, 0) AS christian,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Acoustic/Instrumental') / 60000.0, 0) AS acoustic_instrumental,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Brazilian') / 60000.0, 0) AS brazilian,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Chill') / 60000.0, 0) AS chill,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Children') / 60000.0, 0) AS children,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Funk') / 60000.0, 0) AS funk,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Alternative') / 60000.0, 0) AS alternative,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Dance') / 60000.0, 0) AS dance,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Metal') / 60000.0, 0) AS metal,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Musical') / 60000.0, 0) AS musical,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Jazz') / 60000.0, 0) AS jazz,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Punk') / 60000.0, 0) AS punk,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Country') / 60000.0, 0) AS country,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Classical') / 60000.0, 0) AS classical,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'world') / 60000.0, 0) AS world,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'emo') / 60000.0, 0) AS emo,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'funny') / 60000.0, 0) AS funny,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'Workout') / 60000.0, 0) AS workout,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.genre_group = 'xmas') / 60000.0, 0) AS xmas
FROM mi_musica_total m
JOIN mis_artistas_total a ON m.artistname = a.artistname
WHERE a.genre IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT * FROM spotify_total_by_year_genre;

-- CREATE TABLE spotify_total_by_hour AS
-- SELECT
--     h.hour,
--     COALESCE(ranked.total_minutes, 0) AS total_minutes,
--     ranked.most_listened_genre
-- FROM generate_series(0, 23) AS h(hour)
-- LEFT JOIN (
--     SELECT
--         EXTRACT(HOUR FROM m.started_at)::INTEGER AS hour,
--         SUM(m.msplayed) / 60000.0 AS total_minutes,
--         a.general_genre AS most_listened_genre,
--         ROW_NUMBER() OVER (PARTITION BY EXTRACT(HOUR FROM m.started_at) ORDER BY SUM(m.msplayed) DESC) AS rn
--     FROM mi_musica m
--     JOIN mis_artistas a ON m.artistname = a.artistname
--     WHERE a.genre IS NOT NULL
--     GROUP BY EXTRACT(HOUR FROM m.started_at), a.general_genre
-- ) ranked ON h.hour = ranked.hour AND ranked.rn = 1
-- ORDER BY h.hour;

CREATE TABLE spotify_total_by_hour AS
SELECT
    h.hour,
    COALESCE(ranked.total_minutes, 0) AS total_minutes,
    ranked.most_listened_genre,
    COALESCE(ranked.most_listened_genre_minutes, 0) AS most_listened_genre_minutes,
    ranked.second_most_listened_genre,
    COALESCE(ranked.second_most_listened_genre_minutes, 0) AS second_most_listened_genre_minutes,
    ranked.third_most_listened_genre,
    COALESCE(ranked.third_most_listened_genre_minutes, 0) AS third_most_listened_genre_minutes
FROM generate_series(0, 23) AS h(hour)
LEFT JOIN (
    SELECT
        hour,
        SUM(total_minutes) AS total_minutes,
        MAX(CASE WHEN rn = 1 THEN most_listened_genre END) AS most_listened_genre,
        MAX(CASE WHEN rn = 1 THEN total_minutes END) AS most_listened_genre_minutes,
        MAX(CASE WHEN rn = 2 THEN most_listened_genre END) AS second_most_listened_genre,
        MAX(CASE WHEN rn = 2 THEN total_minutes END) AS second_most_listened_genre_minutes,
        MAX(CASE WHEN rn = 3 THEN most_listened_genre END) AS third_most_listened_genre,
        MAX(CASE WHEN rn = 3 THEN total_minutes END) AS third_most_listened_genre_minutes
    FROM (
        SELECT
            EXTRACT(HOUR FROM m.starttime_arg)::INTEGER AS hour,
            a.genre_group AS most_listened_genre,
            SUM(m.msplayed) / 60000.0 AS total_minutes,
            ROW_NUMBER() OVER (
                PARTITION BY EXTRACT(HOUR FROM m.starttime_arg)
                ORDER BY SUM(m.msplayed) DESC
            ) AS rn
        FROM mi_musica_total m
          JOIN mis_artistas_total a ON m.artistname = a.artistname
        WHERE a.genre IS NOT NULL
        GROUP BY EXTRACT(HOUR FROM m.starttime_arg), a.genre_group
    ) genre_ranked
    GROUP BY hour
) ranked ON h.hour = ranked.hour
ORDER BY h.hour;

SELECT * FROM spotify_total_by_hour;