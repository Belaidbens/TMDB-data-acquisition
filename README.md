# TMDB Data Acquisition

Data acquisition, processing, and mining project based on the **TMDB API**.

The dataset contains US-origin **Drama and/or Thriller movies released between 2020 and 2025**, together with selected cast and crew information.

## TMDB API documentation

- [TMDB Discover Movie API](https://developer.themoviedb.org/reference/discover-movie)
- [TMDB Movie Credits API](https://developer.themoviedb.org/reference/movie-credits)

Main endpoints used:

```text
/discover/movie
/movie/{movie_id}/credits
```

## Project scope

Movies are selected using:

```text
Release period       2020-01-01 → 2025-12-31
Origin country       US
Genres               Drama (18) OR Thriller (53)
Minimum vote count   100
Adult content        excluded
Language             en-US
```

For each movie, the dataset keeps:

- top 6 billed actors;
- directors;
- producers;
- directors of photography.

## Dataset

Raw datasets:

```text
data/raw/movies.parquet
data/raw/credits.parquet
```

Current size:

```text
Movies   : 1,208 rows
Credits  : 14,252 rows
```

Processed datasets are stored separately under:

```text
data/processed/
```

## Setup

The project uses **Python 3.13**.

Run:

```bash
chmod +x setup.sh
./setup.sh
```

The script:

- checks that Python 3.13 is installed;
- creates `.venv`;
- installs the packages from `requirements.txt`;
- prints the installed package versions.

Activate the environment later with:

```bash
source .venv/bin/activate
```

## Main dependencies

The environment includes:

```text
pandas
numpy
duckdb
requests
beautifulsoup4
matplotlib
seaborn
scikit-learn
mlxtend
pyarrow
```

See `requirements.txt` for the complete list and versions.

## Project workflow

```text
acquisition → EDA → cleaning → mining
```

The main outputs include:

```text
acquisition_log.json
findings.md
cleaning_decisions.md
data/raw/
data/processed/
```

The mining stage currently includes **k-means clustering of movies** using release year, vote information, popularity, and genre features.

Project structure
tmdb-data-acquisition/
│
├── data/
│   ├── raw/
│   │   ├── movies.parquet
│   │   └── credits.parquet
│   │
│   └── processed/
│       ├── movies_clean.parquet
│       └── credits_clean.parquet
│
├── cache/
│
├── notebooks/
│   ├── acquisition.ipynb
│   ├── eda.ipynb
│   ├── cleaning.ipynb
│   └── clustering.ipynb
│
├── acquisition_log.json
├── findings.md
├── cleaning_decisions.md
├── README.md
└── requirements.txt


Data cleaning
Cleaning is deliberately conservative.

The raw datasets are never modified in place.

The main decisions are:
- convert release dates to datetime;
- preserve structural missing values;
- retain plausible extreme values;
- verify duplicate and referential integrity constraints;
- flag incomplete selected credits instead of automatically deleting movies;
- keep one movie per row in the main movie dataset.
Cleaned datasets are stored separately from the raw acquisition data.

Clustering
The first mining task uses k-means clustering.
Unit of analysis
One row = one movie
The goal is to discover groups of films with similar profiles.
Features
The clustering representation uses:
year
log_vote_count
vote_average
log_popularity
genre indicators
vote_count and popularity are transformed using:
log(1 + x)
because of their strongly right-skewed distributions.

Continuous variables are standardized before clustering.

Genres are represented using multi-hot encoding.

The final clustering feature matrix contains:
1,208 movies × 23 features

Choosing the number of clusters
K-means was tested for:
k = 2, ..., 8
using:
initialization = k-means++
n_init         = 10
random_state   = 0
Both inertia and silhouette score were used as diagnostics.

The candidate solutions were also evaluated according to:
- cluster sizes;
- interpretability;
- movie profiles;
- genre distributions;
- actual movies contained in each cluster.
The final selected solution uses:
k = 4

Cluster interpretation
Cluster	Interpretation
0	Low-engagement, lower-rated thriller-oriented films
1	Recent moderate-engagement drama/thriller releases
2	High-profile, high-engagement films
3	Older, well-rated drama-oriented filmsCluster 0
Mostly Thriller and Drama movies, with relatively high proportions of Horror, Action and Crime.

This cluster has the lowest average:
- vote count;
- rating;
- popularity.
Cluster 1
Contains mainly recent movies, with an average release year close to 2024.

The films have moderate:
- engagement;
- ratings;
- popularity.
Cluster 2
Contains the most visible and highly engaged-with films.

Examples include:
- Oppenheimer;
- The Batman;
- Top Gun: Maverick;
- Tenet;
- John Wick: Chapter 4.
This cluster has the highest average vote count, popularity and rating.
Cluster 3
Contains mostly older, well-rated films with moderate-to-high engagement.

Drama is particularly dominant in this cluster, representing approximately 75% of its films.

## Authentication

TMDB API authentication uses a Bearer token.

The API token should be configured locally and must **not** be committed to the repository.

