CREATE TABLE mi_musica (
    endtime TIMESTAMP,
    artistname VARCHAR(255),
    trackname VARCHAR(255),
    msplayed INTEGER
);

CREATE TABLE mi_musica_total (
    endtime TIMESTAMP,
    artistname VARCHAR(255),
    trackname VARCHAR(255),
    msplayed INTEGER
);

COPY mi_musica_total FROM '/tmp/musica_total.csv' WITH (FORMAT csv, HEADER true);

CREATE TABLE mis_artistas (
    artistname VARCHAR(255) PRIMARY KEY,
    genre VARCHAR(255),
    spotifyid VARCHAR(255) NOT NULL
);

CREATE TABLE mis_artistas_total (
    artistname VARCHAR(255) PRIMARY KEY,
    genre VARCHAR(255),
    spotifyid VARCHAR(255) NOT NULL
);

ALTER TABLE mi_musica
    ADD COLUMN started_at TIMESTAMP GENERATED ALWAYS AS (endtime - (msplayed * INTERVAL '1 millisecond')) STORED;

ALTER TABLE mis_artistas
    DROP COLUMN IF EXISTS general_genre;

ALTER TABLE mis_artistas
    ADD COLUMN general_genre VARCHAR(255) GENERATED ALWAYS AS (CASE
        WHEN genre IS NULL OR genre = '' THEN NULL
        WHEN genre ILIKE '%rock%' THEN 'rock'
        WHEN genre ILIKE '%pop%' THEN 'pop'
        WHEN genre ILIKE '%indie%' THEN 'indie'
        WHEN genre ILIKE '%latin%' THEN 'latin'
        WHEN genre ILIKE '%reggae%' THEN 'reggae'
        WHEN genre ILIKE '%alternative%' THEN 'alternative'
        WHEN genre ILIKE '%folklore%' THEN 'folklore'
        WHEN genre ILIKE '%house%' THEN 'house'
        WHEN genre ILIKE '%electronic%' THEN 'electronic'
        WHEN genre ILIKE '%funk%' THEN 'funk'
        WHEN genre ILIKE '%trap%' THEN 'trap'
        WHEN genre ILIKE '%rap%' THEN 'rap'
        WHEN genre ILIKE '%hip hop%' THEN 'hip hop'
        WHEN genre ILIKE '%soul%' THEN 'soul'
        WHEN genre ILIKE '%jazz%' THEN 'jazz'
        WHEN genre ILIKE '%disco%' THEN 'disco'
        WHEN genre ILIKE '%worship%' OR genre ILIKE '%christian%' OR genre ILIKE '%catholic%' THEN 'religious'
        WHEN genre ILIKE '%sertanejo%' THEN 'sertanejo'
        ELSE genre
    END) STORED;

-- axé: #FF0000
-- mariachi: #FF7F00
-- trova: #FFFF00
-- downtempo: #00FF00
-- latin: #00FFFF
-- NULL: #0000FF
-- punk: #4B0082
-- candombe: #9400D3
-- bossa nova: #FF1493
-- singer-songwriter: #FFB6C1
-- ska: #FFC0CB
-- cuarteto: #FFD700
-- lo-fi: #FFA500
-- rock: #FF4500
-- chamber music: #FF6347
-- r&b: #FF69B4
-- folklore: #FF8C00
-- soul: #FFA07A
-- indie: #FFB347
-- salsa: #FFDAB9
-- house: #FFE4B5
-- anti-folk: #FFFACD
-- post-punk: #2F4F4F
-- merengue: #FF1744
-- bolero: #BA55D3
-- motown: #32CD32
-- rap: #00008B
-- corrido: #8B0000
-- uk garage: #00BFFF
-- ambient: #E0FFFF
-- jam band: #DAA520
-- alté: #8A2BE2
-- trip hop: #4B0082
-- pop: #FF10F0
-- big beat: #00FF7F
-- neo-psychedelic: #7FFF00
-- musicals: #ADFF2F
-- lounge: #9ACD32
-- disco: #FFD700
-- nu metal: #696969
-- trap: #DC143C
-- bachata: #FF69B4
-- grunge: #800080
-- funk: #32CD32
-- jazz: #CD853F
-- hip hop: #FF0000
-- sertanejo: #20B2AA
-- new wave: #1E90FF
-- cumbia: #FF8C00
-- cha cha cha: #FFB347
-- mpb: #6495ED
-- melodic techno: #00FA9A
-- religious: #808080
-- christmas: #00FF00
-- corridos tumbados: #FF1493
-- alternative: #4169E1
-- reggae: #008000
-- lullaby: #FFC0CB
-- rkt: #FF4500
-- chanson: #FFE4B5
-- children's music: #87CEEB
ALTER TABLE mis_artistas
    DROP COLUMN IF EXISTS genre_color;

ALTER TABLE mis_artistas
    ADD COLUMN genre_color VARCHAR(7) GENERATED ALWAYS AS (CASE
        WHEN genre IS NULL OR genre = '' THEN '#0000FF'
        WHEN genre ILIKE '%rock%' THEN '#FF4500'
        WHEN genre ILIKE '%pop%' THEN '#FF10F0'
        WHEN genre ILIKE '%indie%' THEN '#FFB347'
        WHEN genre ILIKE '%latin%' THEN '#00FFFF'
        WHEN genre ILIKE '%reggae%' THEN '#008000'
        WHEN genre ILIKE '%alternative%' THEN '#4169E1'
        WHEN genre ILIKE '%folklore%' THEN '#FF8C00'
        WHEN genre ILIKE '%house%' THEN '#FFE4B5'
        WHEN genre ILIKE '%electronic%' THEN '#000000'
        WHEN genre ILIKE '%funk%' THEN '#32CD32'
        WHEN genre ILIKE '%trap%' THEN '#DC143C'
        WHEN genre ILIKE '%rap%' THEN '#00008B'
        WHEN genre ILIKE '%hip hop%' THEN '#FF0000'
        WHEN genre ILIKE '%soul%' THEN '#FFA07A'
        WHEN genre ILIKE '%jazz%' THEN '#CD853F'
        WHEN genre ILIKE '%disco%' THEN '#FFD700'
        WHEN genre ILIKE '%worship%' OR genre ILIKE '%christian%' OR genre ILIKE '%catholic%' THEN '#808080'
        WHEN genre ILIKE '%sertanejo%' THEN '#20B2AA'
        WHEN genre = 'axé' THEN '#FF0000'
        WHEN genre = 'mariachi' THEN '#FF7F00'
        WHEN genre = 'trova' THEN '#FFFF00'
        WHEN genre = 'downtempo' THEN '#00FF00'
        WHEN genre = 'punk' THEN '#4B0082'
        WHEN genre = 'candombe' THEN '#9400D3'
        WHEN genre = 'bossa nova' THEN '#FF1493'
        WHEN genre = 'singer-songwriter' THEN '#FFB6C1'
        WHEN genre = 'ska' THEN '#FFC0CB'
        WHEN genre = 'cuarteto' THEN '#FFD700'
        WHEN genre = 'lo-fi' THEN '#FFA500'
        WHEN genre = 'chamber music' THEN '#FF6347'
        WHEN genre = 'r&b' THEN '#FF69B4'
        WHEN genre = 'salsa' THEN '#FFDAB9'
        WHEN genre = 'anti-folk' THEN '#FFFACD'
        WHEN genre = 'post-punk' THEN '#2F4F4F'
        WHEN genre = 'merengue' THEN '#FF1744'
        WHEN genre = 'bolero' THEN '#BA55D3'
        WHEN genre = 'motown' THEN '#32CD32'
        WHEN genre = 'corrido' THEN '#8B0000'
        WHEN genre = 'uk garage' THEN '#00BFFF'
        WHEN genre = 'ambient' THEN '#E0FFFF'
        WHEN genre = 'jam band' THEN '#DAA520'
        WHEN genre = 'alté' THEN '#8A2BE2'
        WHEN genre = 'trip hop' THEN '#4B0082'
        WHEN genre = 'big beat' THEN '#00FF7F'
        WHEN genre = 'neo-psychedelic' THEN '#7FFF00'
        WHEN genre = 'musicals' THEN '#ADFF2F'
        WHEN genre = 'lounge' THEN '#9ACD32'
        WHEN genre = 'nu metal' THEN '#696969'
        WHEN genre = 'bachata' THEN '#FF69B4'
        WHEN genre = 'grunge' THEN '#800080'
        WHEN genre = 'new wave' THEN '#1E90FF'
        WHEN genre = 'cumbia' THEN '#FF8C00'
        WHEN genre = 'cha cha cha' THEN '#FFB347'
        WHEN genre = 'mpb' THEN '#6495ED'
        WHEN genre = 'melodic techno' THEN '#00FA9A'
        WHEN genre = 'christmas' THEN '#00FF00'
        WHEN genre = 'corridos tumbados' THEN '#FF1493'
        WHEN genre = 'lullaby' THEN '#FFC0CB'
        WHEN genre = 'rkt' THEN '#FF4500'
        WHEN genre = 'chanson' THEN '#FFE4B5'
        WHEN genre = 'children''s music' THEN '#87CEEB'
        ELSE '#000000'
    END) STORED;

SELECT * FROM mi_musica WHERE artistname = 'Sports';

SELECT * FROM mis_artistas WHERE artistname = 'El Cuarteto De Nos';

UPDATE mis_artistas
SET genre = 'rock argentino'
WHERE artistname = 'El Cuarteto De Nos';

SELECT 
    general_genre,
    SUM(msplayed) AS total_msplayed
FROM mis_artistas a
    JOIN mi_musica m ON a.artistname = m.artistname
WHERE a.genre IS NOT NULL
GROUP BY a.general_genre
ORDER BY total_msplayed DESC;


SELECT DISTINCT artistname FROM mi_musica;

DROP TABLE IF EXISTS mi_musica;

COPY mi_musica FROM '/tmp/musica.csv' WITH (FORMAT csv, HEADER true);

COPY mis_artistas FROM '/tmp/artists.csv' WITH (FORMAT csv, HEADER true);

-- Data select
-- all music
SELECT
    m.id,
    m.trackname,
    m.started_at::TIMESTAMP(0) AS starttime,
    m.endtime,
    m.msplayed,
    m.msplayed / (60 * 1000.0) AS "minutes played",
    m.artistname,
    a.genre AS artist_genre,
    a.general_genre AS artist_general_genre
FROM mi_musica m
    JOIN mis_artistas a ON m.artistname = a.artistname
WHERE a.genre IS NOT NULL;

-- music with non null genre
SELECT
    m.id,
    m.trackname,
    m.started_at::TIMESTAMP(0) AS starttime,
    m.endtime,
    m.msplayed,
    -- m.msplayed / (60 * 1000.0) AS "minutes played",
    m.artistname,
    a.genre AS artist_genre,
    a.general_genre AS artist_general_genre
FROM mi_musica m
    JOIN mis_artistas a ON m.artistname = a.artistname
WHERE a.genre IS NOT NULL;

-- general genres
SELECT DISTINCT artistname, genre_color
FROM mis_artistas;

-- artists
SELECT artistname, general_genre FROM mis_artistas;

SELECT artistname, genre FROM mis_artistas;

SELECT
    m.id,
    m.trackname,
    m.started_at::TIMESTAMP(0) AS starttime,
    m.endtime,
    m.msplayed,
    m.msplayed / (60 * 1000.0) AS "minutes played",
    m.artistname,
    a.genre AS artist_genre,
    a.general_genre AS artist_general_genre
FROM mi_musica m
    JOIN mis_artistas a ON m.artistname = a.artistname
WHERE a.general_genre IN (
    SELECT
        a2.general_genre AS artist_general_genre
    FROM mi_musica m2
        JOIN mis_artistas a2 ON m2.artistname = a2.artistname
    GROUP BY a2.general_genre
    ORDER BY SUM(m2.msplayed) DESC
    LIMIT 15
);

CREATE TABLE spotify_by_date_genre AS
SELECT
    m.started_at::date AS date,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'rock') / 60000.0, 0) AS rock_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'pop') / 60000.0, 0) AS pop_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'jazz') / 60000.0, 0) AS jazz_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'hip hop') / 60000.0, 0) AS hip_hop_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'electronic') / 60000.0, 0) AS electronic_minutes
FROM mi_musica m
JOIN mis_artistas a ON m.artistname = a.artistname
WHERE a.genre IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT * FROM spotify_by_date_genre;

DROP TABLE IF EXISTS spotify_by_date_genre;

DROP TABLE IF EXISTS spotify_by_month_genre;

CREATE TABLE spotify_by_month_genre AS
SELECT
    date_trunc('month', m.started_at)::date AS month,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'rock') / 60000.0, 0) AS rock_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'indie') / 60000.0, 0) AS indie_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'reggae') / 60000.0, 0) AS reggae_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'pop') / 60000.0, 0) AS pop_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'trap') / 60000.0, 0) AS trap_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'bossa nova') / 60000.0, 0) AS bossa_nova_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'latin') / 60000.0, 0) AS latin_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'house') / 60000.0, 0) AS house_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'neo-psychedelic') / 60000.0, 0) AS neo_psychedelic_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'trova') / 60000.0, 0) AS trova_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'axé') / 60000.0, 0) AS axe_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'motown') / 60000.0, 0) AS motown_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'candombe') / 60000.0, 0) AS candombe_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'trip hop') / 60000.0, 0) AS trip_hop_minutes,
    COALESCE(SUM(m.msplayed) FILTER (WHERE a.general_genre = 'mpb') / 60000.0, 0) AS mpb_minutes
FROM mi_musica m
JOIN mis_artistas a ON m.artistname = a.artistname
WHERE a.genre IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT * FROM spotify_by_month_genre;

CREATE TABLE spotify_by_hour AS
SELECT
    h.hour,
    COALESCE(ranked.total_minutes, 0) AS total_minutes,
    ranked.most_listened_genre
FROM generate_series(0, 23) AS h(hour)
LEFT JOIN (
    SELECT
        EXTRACT(HOUR FROM m.started_at)::INTEGER AS hour,
        SUM(m.msplayed) / 60000.0 AS total_minutes,
        a.general_genre AS most_listened_genre,
        ROW_NUMBER() OVER (PARTITION BY EXTRACT(HOUR FROM m.started_at) ORDER BY SUM(m.msplayed) DESC) AS rn
    FROM mi_musica m
    JOIN mis_artistas a ON m.artistname = a.artistname
    WHERE a.genre IS NOT NULL
    GROUP BY EXTRACT(HOUR FROM m.started_at), a.general_genre
) ranked ON h.hour = ranked.hour AND ranked.rn = 1
ORDER BY h.hour;

CREATE TABLE spotify_by_hour AS
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
            EXTRACT(HOUR FROM m.started_at)::INTEGER AS hour,
            a.general_genre AS most_listened_genre,
            SUM(m.msplayed) / 60000.0 AS total_minutes,
            ROW_NUMBER() OVER (
                PARTITION BY EXTRACT(HOUR FROM m.started_at)
                ORDER BY SUM(m.msplayed) DESC
            ) AS rn
        FROM mi_musica m
        JOIN mis_artistas a ON m.artistname = a.artistname
        WHERE a.genre IS NOT NULL
        GROUP BY EXTRACT(HOUR FROM m.started_at), a.general_genre
    ) genre_ranked
    GROUP BY hour
) ranked ON h.hour = ranked.hour
ORDER BY h.hour;

DROP TABLE IF EXISTS spotify_by_hour;

SELECT * FROM spotify_by_hour;

SELECT * FROM mis_artistas;

SELECT DISTINCT artistname FROM mi_musica_total WHERE artistname IS NOT NULL;
