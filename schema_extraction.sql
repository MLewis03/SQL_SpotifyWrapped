---------------------------------------------------------------------
-- SCHEMA EXTRACTION FOR SPOTIFY RAW DATA
-- This script inspects JSON files in raw_data/ and outputs:
--   • Column names
--   • Inferred types
--   • Null counts
--   • Type inconsistencies
--   • Timestamp format checks
--   • Row counts
---------------------------------------------------------------------

---------------------------------------------------------------------
-- 1. STREAMING HISTORY — MUSIC
---------------------------------------------------------------------

-- Preview
SELECT *
FROM read_json_auto('raw_data/StreamingHistory_music_0.json')
LIMIT 5;

-- Schema
DESCRIBE SELECT *
FROM read_json_auto('raw_data/StreamingHistory_music_0.json');

-- Null counts
SELECT 
    COUNT(*) AS total_rows,
    SUM(trackName IS NULL) AS null_trackName,
    SUM(artistName IS NULL) AS null_artistName,
    SUM(msPlayed IS NULL) AS null_msPlayed,
    SUM(endTime IS NULL) AS null_endTime
FROM read_json_auto('raw_data/StreamingHistory_music_0.json');

-- Type inconsistencies
SELECT 
    typeof(msPlayed) AS msPlayed_type,
    COUNT(*) AS count
FROM read_json_auto('raw_data/StreamingHistory_music_0.json')
GROUP BY 1;

-- Timestamp format check
SELECT DISTINCT
    CASE
        WHEN REGEXP_MATCHES(endTime, '^[0-9]{13}$') THEN 'epoch_ms'
        WHEN REGEXP_MATCHES(endTime, '^[0-9]{10}$') THEN 'epoch_s'
        WHEN REGEXP_MATCHES(endTime, '^[0-9]{4}-[0-9]{2}-[0-9]{2}') THEN 'iso8601'
        ELSE 'unknown'
    END AS timestamp_format
FROM read_json_auto('raw_data/StreamingHistory_music_0.json');


---------------------------------------------------------------------
-- 2. STREAMING HISTORY — PODCAST
---------------------------------------------------------------------

SELECT *
FROM read_json_auto('raw_data/StreamingHistory_podcast_0.json')
LIMIT 5;

DESCRIBE SELECT *
FROM read_json_auto('raw_data/StreamingHistory_podcast_0.json');

SELECT 
    COUNT(*) AS total_rows,
    SUM(endTime IS NULL) AS null_endTime,
    SUM(podcastName IS NULL) AS null_podcastName,
    SUM(episodeName IS NULL) AS null_episodeName,
    SUM(msPlayed IS NULL) AS null_msPlayed
FROM read_json_auto('raw_data/StreamingHistory_podcast_0.json');

SELECT 
    typeof(msPlayed) AS msPlayed_type,
    COUNT(*) AS count
FROM read_json_auto('raw_data/StreamingHistory_podcast_0.json')
GROUP BY 1;

SELECT DISTINCT
    CASE
        WHEN REGEXP_MATCHES(endTime, '^[0-9]{13}$') THEN 'epoch_ms'
        WHEN REGEXP_MATCHES(endTime, '^[0-9]{10}$') THEN 'epoch_s'
        WHEN REGEXP_MATCHES(endTime, '^[0-9]{4}-[0-9]{2}-[0-9]{2}') THEN 'iso8601'
        ELSE 'unknown'
    END AS timestamp_format
FROM read_json_auto('raw_data/StreamingHistory_podcast_0.json');


---------------------------------------------------------------------
-- 3. PLAYLIST DATA
---------------------------------------------------------------------

SELECT *
FROM read_json_auto('raw_data/Playlist1.json')
LIMIT 5;

WITH playlist_rows AS (
    SELECT
        playlist.value AS playlist
    FROM read_json('raw_data/Playlist1.json'),
         json_each(playlists) AS playlist
),
item_rows AS (
    SELECT
        json_extract(playlist, '$.name') AS playlist_name,
        json_extract(playlist, '$.lastModifiedDate') AS last_modified,
        json_extract(playlist, '$.items') AS items
    FROM playlist_rows
),
flattened AS (
    SELECT
        playlist_name,
        last_modified,
        json_extract(item.value, '$.track.trackName') AS track_name,
        json_extract(item.value, '$.track.artistName') AS artist_name,
        json_extract(item.value, '$.track.albumName') AS album_name,
        json_extract(item.value, '$.track.trackUri') AS track_uri,
        json_extract(item.value, '$.addedDate') AS added_date
    FROM item_rows,
         json_each(items) AS item
)
SELECT *
FROM flattened;

---------------------------------------------------------------------
-- 4. SEARCH QUERIES
---------------------------------------------------------------------

SELECT *
FROM read_json_auto('raw_data/SearchQueries.json')
LIMIT 5;

DESCRIBE SELECT *
FROM read_json_auto('raw_data/SearchQueries.json');

SELECT 
    COUNT(*) AS total_rows
FROM read_json_auto('raw_data/SearchQueries.json');

-- Check for weird timestamps or query times if present
SELECT DISTINCT
    CASE
        WHEN REGEXP_MATCHES(searchTime, '^[0-9]{13}$') THEN 'epoch_ms'
        WHEN REGEXP_MATCHES(searchTime, '^[0-9]{10}$') THEN 'epoch_s'
        WHEN REGEXP_MATCHES(searchTime, '^[0-9]{4}-[0-9]{2}-[0-9]{2}') THEN 'iso8601'
        ELSE 'unknown'
    END AS timestamp_format
FROM read_json_auto('raw_data/SearchQueries.json')
WHERE searchTime IS NOT NULL;


---------------------------------------------------------------------
-- 5. MARQUEE DATA
---------------------------------------------------------------------

SELECT *
FROM read_json_auto('raw_data/Marquee.json')
LIMIT 5;

DESCRIBE SELECT *
FROM read_json_auto('raw_data/Marquee.json');

SELECT 
    COUNT(*) AS total_rows
FROM read_json_auto('raw_data/Marquee.json');

---------------------------------------------------------------------
-- 6. YOUR LIBRARY
---------------------------------------------------------------------

WITH rows AS (
    SELECT value AS track_obj
    FROM read_json('raw_data/YourLibrary.json'),
         json_each(tracks)
),
flat AS (
    SELECT
        json_extract(track_obj, '$.artist') AS artist,
        json_extract(track_obj, '$.album') AS album,
        json_extract(track_obj, '$.track') AS track,
        json_extract(track_obj, '$.uri') AS uri
    FROM rows
)
SELECT *
FROM flat
LIMIT 10;
