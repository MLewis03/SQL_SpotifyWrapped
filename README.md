# My 2024 Spotify Listening Behavior: An End‑to‑End Analytics Engineering Project
## 📌 Project Overview
This project is an end‑to‑end analytics engineering build that transforms my personal 2024 Spotify streaming data into a fully modeled analytics platform. The goal is to demonstrate Level II–ready SQL, data modeling, and pipeline design by taking raw JSON/CSV exports from Spotify and turning them into clean, reliable, analysis‑ready datasets — and ultimately a Streamlit dashboard that surfaces insights about my listening habits, skip behavior, session patterns, and artist engagement.

The project is intentionally structured to mirror a modern analytics engineering workflow:
**Raw → Staging → Dimensions/Facts → Marts → Dashboard**

All tools used are free and open‑source (DuckDB, Python, Streamlit, dbdiagram.io, GitHub).

This repository is actively under development. Sections below outline the planned architecture and deliverables as the project progresses.

## 🗂️ Repository Structure (In Progress)
Code
/data_raw               # Raw Spotify export files
/data_clean             # Cleaned intermediate outputs
/models                 # SQL models (staging, dimensions, facts, marts)
/dashboard              # Streamlit dashboard code
/docs                   # ERD, data dictionary, screenshots
/notebooks              # Optional exploratory analysis

## 🎯 Project Goals
* Build a realistic analytics engineering pipeline using personal Spotify data
* Demonstrate production‑minded SQL (window functions, sessionization, deduplication)
* Create dimensional models (tracks, artists) and fact tables (listening events, sessions)
* Develop behavioral analytics models (skip patterns, listening LTV, search behavior)
* Deliver a polished Streamlit dashboard with interactive insights
* Show clear documentation, modeling discipline, and end‑to‑end ownership

## 📥 Data Source
This project uses my 2024 Spotify personal streaming data, exported through Spotify’s privacy portal.

The dataset includes fields such as:
* Track name
* Artist
* Timestamp
* Duration played
* Total track duration
* Skip behavior
* Playlist context
* Search queries
* Device type

Raw files are stored in /data_raw and will be documented as the project progresses.

## 🧱 Architecture (Planned)
Data Flow:
**Raw → Staging (Silver) → Dimensions/Facts (Gold) → Marts → Dashboard**

Tools:
* DuckDB for local analytics warehouse
* Python for ingestion and transformation
* SQL for modeling
* Streamlit for dashboarding
* dbdiagram.io for ERD creation
* GitHub for version control and documentation

## 🧩 Data Modeling (Planned)
ERD
(ERD will be added here once modeling begins.)

Staging Models
* stg_stream_history
* stg_search_history
* stg_playlist_context

Dimension Tables
* dim_track
* dim_artist

Fact Tables
* fct_listening_events
* fct_sessions

Marts
* artist_ltv
* skip_behavior
* listening_trends

## 🧪 Data Quality (Planned)
* This project will include:
* Null checks
* Unique key enforcement
* Duration sanity checks
* Sessionization validation
* Referential integrity checks

## 📊 Dashboard (Planned)
* The final Streamlit dashboard will include:
* Listening KPIs
* Top artists and tracks
* Skip behavior analysis
* Session analytics
* Search behavior patterns
* Time‑of‑day and day‑of‑week trends
* Screenshots will be added as the dashboard is developed.

## 🚀 How to Run the Project (Coming Soon)
Instructions for:
* Installing dependencies
* Initializing DuckDB
* Running the Streamlit app
Will be added once the first working version is complete.

## 🔍 Key Insights (To Be Added Later)
This section will summarize the most interesting findings once the analysis is complete.

## 🛠️ Future Enhancements
* Genre enrichment via Spotify API
* Predictive skip model
* Recommendation engine
* Automated pipeline orchestration (GitHub Actions or Airflow)

## ✨ Why This Project Matters
This project is designed to demonstrate the technical depth, modeling discipline, and analytical thinking expected of an Analytics Engineer II. It showcases my ability to work with messy real‑world data, design scalable models, write production‑grade SQL, and communicate insights through a polished dashboard.