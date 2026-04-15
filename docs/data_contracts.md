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
Columns & Types
| Column | Type	| Nullable	| Notes |
|--------|------|-----------|-------|
| name | VARCHAR | Yes | Playlist name|
| lastModifiedDate | VARCHAR | Yes | Date playlist was last modified |
| items	| JSON | Yes | Array of playlist entries (tracks, episodes, audiobooks, local files) |
| description | VARCHAR | Yes | Optional playlist description | 
| numberOfFollowers | BIGINT | Yes | Follower count for the playlist |

Item Structure (inside the items column above)
| Field | Type	| Nullable	| Notes |
|--------|------|-----------|-------|
| track.trackName | VARCHAR | Yes | Track title |
| track.artistName | VARCHAR | Yes | Primary artist |
| track.albumName | VARCHAR | Yes | Album title |
| track.trackUri | VARCHAR | Yes | Spotify URI (Uniform Resource Identifier) | 
| episode | JSON | Yes | Podcast episode object (not populated in current export) |
| audiobook | JSON | Yes | Audiobook object (not populated in current export) |
| localTrack | JSON | Yes | Local file metadata (not populated in current export) |
| addedDate | VARCHAR | Yes | Date item was added to playlist |

Known Issues
* items is a nested array and must be unnested for analysis
* Only track objects are populated in current export; episode, audiobook, and localTrack appear as null 
* lastModifiedDate and addedDate are stored as strings, not timestamps

### 🔍 2.4 SearchQueries.json
Columns & Types
| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| platform	| VARCHAR | Yes | User search platform |
| searchTime | VARCHAR | Yes | Timestamp of search |
| searchQuery | VARCHAR | Yes | User search query |
| searchInteractionURIs | VARCHAR[] | Yes | URIs of Spotify entities interacted with after the search |

Known Issues
* searchTime is ISO8601 format; same as music streaming history in 2.1

### 📣 2.5 Marquee.json
Columns & Types
| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| artistName | VARCHAR | Yes | Name of artist |
| segment | VARCHAR | Yes | Segment of listeners to which user belongs  |

No Known Issues


### 📚 2.6 YourLibrary.json
Columns & Types
| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| artist | VARCHAR | Yes | Name of artist |
| album | VARCHAR | Yes | Album title |
| track | VARCHAR | Yes	| Name of track (song, episode etc) |
| uri | VARCHAR | Yes | Spotify URI (Uniform Resource Identifier) |

No Known Issues

## ⚠️ 3. Cross‑File Data Quality Issues
### 3.1 Timestamp Inconsistencies
Timestamps appear in multiple formats across files:
* ISO8601 strings (e.g., 2024‑05‑24T18:29:50Z)
* ISO8601 with timezone suffixes (e.g., 2024‑10‑28T18:29:50.400Z[UTC])
* Stringified dates without time (e.g., 2024‑05‑24)
* Occasional epoch seconds or milliseconds in other exports

These inconsistencies require normalization during ingestion.

### 3.2 Type Inconsistencies
Several fields vary in type across files or exports:
* msPlayed may appear as a string instead of BIGINT
* Playlist numberOfFollowers may appear as a string
* Arrays (e.g., items, searchInteractionURIs) are not typed consistently
* Some fields (e.g., episode, audiobook, localTrack) appear as JSON objects or null depending on export version

### 3.3 Structural Variability
Different files use different top‑level structures:
* Some files contain a single array (tracks, marquee)
* Others contain an object with a nested array (playlists, searchQueries)
* Some files contain flat objects, others contain nested objects requiring unnesting

This variability requires file‑specific parsing logic.

## 🛠️ 4. Recommended Normalization Rules
| Issue	| Recommendation |
|-------|----------------|
| Mixed timestamp formats |	Convert all timestamps to ISO8601 during ingestion |
| Stringified integers	| Cast to BIGINT in staging models |
| Missing playlist names | Replace with "unknown_playlist" |
| Null or zero durations | Filter or impute depending on downstream use |
| Nested arrays/objects | Flatten during staging |
| Unused nested fields | Drop consistently null objects (episode, audiobook, localTrack) | 

## 📄 5. SQL Used for Schema Extraction
All schema‑profiling SQL (null counts, distinct counts, type checks, JSON unnesting, timestamp detection) is stored in: **schema_extraction.sql**

This file contains the exact queries used to infer the schemas documented in Section 2.

## 🚀 6. Next Steps
* Build stg_ models to normalize timestamps, cast types, and flatten nested structures
* Create analytics‑ready tables for streams, playlists, search behavior, and library items