# 🎧 Raw Spotify Data — Data Contract
This document describes the raw JSON files exported from Spotify and stored in the rawdata/ directory.
All schema information was inferred using SQL (DuckDB) inside VS Code.

The purpose of this data contract is to define:
* Columns present in each raw file
* Inferred data types
* Nullability
* Known issues (missing fields, inconsistent types, timestamp formats)
* Recommended normalization rules for downstream models

## 📁 1. Files Included
| File	| Description |
| ----- | ----------- |
| StreamingHistory_music_0.json	| Track‑level music listening history |
| StreamingHistory_podcast_0.json | Podcast listening history |
| Playlist1.json | User playlist metadata |
| SearchQueries.json | Search query history |
| Marquee.json | Artist and listener status |
| YourLibrary.json | Saved tracks, albums, and artists |

## 🎼 2. Schema Details by File
### 🎵 2.1 StreamingHistory_music_0.json
Columns & Types
| Column |	Type |	Nullable |	Notes |
|--------|-------|-----------|--------|
| endTime |	VARCHAR	| Yes |	Timestamp stored as text |
| artistName | VARCHAR | Yes | Artist of the track |
| trackName	| VARCHAR |	Yes | Track title |
| msPlayed | BIGINT	| Yes | Milliseconds played |

Potential Issues
* endTime is ISO8601 format

### 🎙️ 2.2 StreamingHistory_podcast_0.json
Columns & Types
| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| endTime | VARCHAR	| Yes |	Timestamp stored as text |
| podcastName | VARCHAR | YES | Podcast title |
| episodeName | VARCHAR | Yes |	Episode title |
| msPlayed | BIGINT | Yes | Milliseconds played |

Known Issues
* endTime is ISO8601 format; same as music streaming history in 2.1

### 🎶 2.3 Playlist1.json
Playlist1.json contains a single top‑level column that is an array of playlist objects.
Each playlist object contains nested metadata and an array of items (tracks, episodes, audiobooks, or local files).
The file must be unnested to analyze track‑level data.

**⏸️ Work paused here — everything below this point is under construction.**


Columns & Types
| Column | Type	| Nullable	| Notes |
|--------|------|-----------|-------|
| playlistName | VARCHAR | Yes | Playlist title; may be empty |
| playlistId | VARCHAR | Yes | Spotify playlist ID |
| numTracks	| BIGINT | Yes | Track count |
| lastModified | VARCHAR | Yes | Timestamp; format varies | 

Known Issues
* Playlist names sometimes missing or blank
* lastModified may be invalid or empty
* Timestamps may be epoch or ISO8601

### 🔍 2.4 SearchQueries.json
Columns & Types
| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| query	| VARCHAR | Yes | User search text |
| queryTime | VARCHAR | Yes | Timestamp of search |
| searchInteraction | VARCHAR | Yes	| Type of interaction (play, view, etc.) |

Known Issues
* Some queries may be empty
* queryTime may be missing or inconsistent
* Some rows may contain nested objects depending on export version

📣 2.5 Marquee.json
Columns & Types
| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| query	| VARCHAR | Yes | User search text |
| queryTime | VARCHAR | Yes | Timestamp of search |
| searchInteraction | VARCHAR | Yes	| Type of interaction (play, view, etc.) |

Known Issues
* Many fields may be missing
* Timestamps may not be standardized

📚 2.6 YourLibrary.json
Columns & Types
| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| query	| VARCHAR | Yes | User search text |
| queryTime | VARCHAR | Yes | Timestamp of search |
| searchInteraction | VARCHAR | Yes	| Type of interaction (play, view, etc.) |

Known Issues
* Some items missing addedAt
* Mixed timestamp formats
* Some entries may be nested objects

## ⚠️ 3. Cross‑File Data Quality Issues
### 3.1 Timestamp Inconsistencies
Across multiple files, timestamps appear in:
* ISO8601 (2023-05-14T12:34:56Z)
* Epoch seconds (1684077296)
* Epoch milliseconds (1684077296123)
* Occasionally malformed strings

### 3.2 Type Inconsistencies
msPlayed sometimes string instead of integer

Playlist counts may appear as strings

Some fields missing entirely depending on export version

### 3.3 Missing or Null Fields
Playlist names

Episode names

Search queries

Library timestamps

## 🛠️ 4. Recommended Normalization Rules
| Issue	| Recommendation |
|-------|----------------|
| Mixed timestamp formats |	Convert all timestamps to ISO8601 during ingestion |
| Stringified integers	| Cast to BIGINT in staging models |
| Missing playlist names | Replace with "unknown_playlist" |
| Null durations | Filter or impute depending on downstream use |
| Nested objects | Flatten during staging |

## 📄 5. SQL Used for Schema Extraction
All SQL queries used to obtain the information contained above can be found in schema_extraction.sql

## 🚀 6. Next Steps
Build staging models to normalize timestamps and types

Add data quality tests (null checks, type checks)

Create analytics‑ready tables for music, podcasts, playlists, and search behavior