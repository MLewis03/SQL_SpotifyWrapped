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
    SUM(episodeName IS NULL) AS null_episodeName,
    SUM(showName IS NULL) AS null_showName,
    SUM(msPlayed IS NULL) AS null_msPlayed,
    SUM(endTime IS NULL) AS null_endTime
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

DESCRIBE SELECT *
FROM read_json_auto('raw_data/Playlist1.json');

SELECT 
    COUNT(*) AS total_rows,
    SUM(playlistName IS NULL OR playlistName = '') AS null_playlistName,
    SUM(playlistId IS NULL) AS null_playlistId,
    SUM(numTracks IS NULL) AS null_numTracks,
    SUM(lastModified IS NULL) AS null_lastModified
FROM read_json_auto('raw_data/Playlist1.json');

SELECT DISTINCT
    CASE
        WHEN REGEXP_MATCHES(lastModified, '^[0-9]{13}$') THEN 'epoch_ms'
        WHEN REGEXP_MATCHES(lastModified, '^[0-9]{10}$') THEN 'epoch_s'
        WHEN REGEXP_MATCHES(lastModified, '^[0-9]{4}-[0-9]{2}-[0-9]{2}') THEN 'iso8601'
        ELSE 'unknown'
    END AS timestamp_format
FROM read_json_auto('raw_data/Playlist1.json');


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
        WHEN REGEXP_MATCHES(queryTime, '^[0-9]{13}$') THEN 'epoch_ms'
        WHEN REGEXP_MATCHES(queryTime, '^[0-9]{10}$') THEN 'epoch_s'
        WHEN REGEXP_MATCHES(queryTime, '^[0-9]{4}-[0-9]{2}-[0-9]{2}') THEN 'iso8601'
        ELSE 'unknown'
    END AS timestamp_format
FROM read_json_auto('raw_data/SearchQueries.json')
WHERE queryTime IS NOT NULL;


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

SELECT *
FROM read_json_auto('raw_data/YourLibrary.json')
LIMIT 5;

DESCRIBE SELECT *
FROM read_json_auto('raw_data/YourLibrary.json');

SELECT 
    COUNT(*) AS total_rows
FROM read_json_auto('raw_data/YourLibrary.json');