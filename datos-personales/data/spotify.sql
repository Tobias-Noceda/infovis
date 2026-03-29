CREATE TABLE mi_musica (
    endtime TIMESTAMP,
    artistname VARCHAR(255),
    trackname VARCHAR(255),
    msplayed INTEGER
);

CREATE TABLE mis_artistas (
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

SELECT * FROM mi_musica WHERE artistname = 'Sports';

SELECT * FROM mis_artistas WHERE artistname = 'El Cuarteto De Nos';

SELECT
    m.id,
    m.trackname,
    m.started_at::TIMESTAMP(0) AS starttime,
    m.endtime,
    m.msplayed,
    m.artistname,
    a.genre AS artist_genre,
    a.general_genre AS artist_general_genre
FROM mi_musica m
    JOIN mis_artistas a ON m.artistname = a.artistname
WHERE a.genre IS NOT NULL;

UPDATE mis_artistas
SET genre = 'rock argentino'
WHERE artistname = 'El Cuarteto De Nos';

SELECT DISTINCT general_genre FROM mis_artistas WHERE general_genre IS NOT NULL;

SELECT DISTINCT artistname FROM mi_musica;

DROP TABLE IF EXISTS mi_musica;

COPY mi_musica FROM '/tmp/musica.csv' WITH (FORMAT csv, HEADER true);

COPY mis_artistas FROM '/tmp/artists.csv' WITH (FORMAT csv, HEADER true);