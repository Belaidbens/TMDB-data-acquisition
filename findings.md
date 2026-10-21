# EDA findings — TMDB movies and credits

**Pair:** BENSAADA Mohand Oubelaid && KHARIONOVSKAIA Polina · 
**Dataset:** TMDB API — US-origin Drama or Thriller movies released from 2020 to 2025, with `vote_count >= 100`; selected credits include the top-6 billed actors and crew jobs Director, Producer, and Director of Photography · **Date:** 2026-10-21  
**Rows × columns:** Movies: 1208 × 9 · Credits: 14252 × 7 · 
**File:** `data/raw/movies.parquet`, `data/raw/credits.parquet`

---

## 1. Missingness

**Which columns, and how much?**

| Column         | Missing | %      | Sentinel   |
| ---            | ---:    | ---:   | ---        |
| Movies dataset | 0       | 0.00%  | None found |
| `department`   | 7191    | 50.46% | None       |
| `job`          | 7191    | 50.46% | None       |
| `billing_order`| 7061    | 49.54% | None       |

**Do they go missing together?**  
`department` and `job` are missing together in all 7191 actor rows. `billing_order` is missing in all 7061 non-actor rows. The missingness follows the person's `role`.

**What is the mechanism?**  
The `role` column fully predicts the missingness. Actors have a billing order but no crew `department` or `job`; directors, producers and cinematographers have `department` and `job`, but no `billing_order`. The missing values are structural and correspond to fields that are not applicable to that role.

**MCAR, MAR or MNAR, and how do you know?**  
The mechanism is consistent with **MAR**, because the missingness is fully explained by the observed `role` column. 

**Decision.**  
Keep all rows and keep these missing values as they are. We do not use `dropna()` and do not impute them, because this would either remove useful credit rows or create artificial information. The evidence is explicit: 7191 actor rows are missing `department` and `job`, while 7061 crew rows are missing `billing_order`, and in every case the missingness is explained by the observed `role` column.

**Decision table.**

| Problem | Evidence | Decision | Output |
| --- | --- | --- | --- |
| Role-dependent missingness | 7191 actor rows missing `department` and `job`; 7061 crew rows missing `billing_order` | Keep the rows and record why the field is not applicable | `missing_reason` |
| Short cast lists | 14 movies have fewer than 6 actors; none have zero actors | Keep these movies and their related credit rows, and flag them instead of dropping them | `cast_short_flag = True` |
| Extreme but valid values | `vote_count` max = 12616, `popularity` max = 107.04 | Keep them because they are plausible and within allowed ranges; describe them in EDA but do not create a separate flag | No flag needed |
| Scope limitation | Filter is US-only, Drama/Thriller, `vote_count >= 100`, 2020–2025 | Keep the restriction and document it as a limitation of the dataset scope | No row-level flag; described as a dataset-level limitation |

**Raw vs cleaned dataset.**  
The raw parquet files remain untouched. We create a flagged version for analysis and keep the decisions auditable: `data/clean/movies_flagged.parquet` and `data/clean/credits_flagged.parquet`. This preserves the original acquisition record while allowing a reproducible, documented cleaning workflow.

**What we did not do.**  
We did not drop rows, we did not impute missing crew titles or missing actor departments, and we did not treat structural NA values as broken records. This is the core cleaning decision for this project: the data are not “bad”; they are domain-consistent but require explicit labeling.

---

## 2. Distributions and outliers

**Per numeric column of interest:**

| Column        | min  | median | max   | Impossible values | Ambiguous values |
| ---           | ---: | ---:   | ---:  | ---:              | ---: |
| `vote_count`  | 100  | 378    | 12616 | 0 below acquisition threshold | 0 identified |
| `vote_average`| 4.03 | 6.44   | 8.40  | 0 outside `[0,10]` | 0 identified |
| `popularity`  | 1.17 | 5.63   | 107.04| 0 negative values observed | 0 identified |

**Impossible** — No impossible numeric movie values were found in the variables inspected so far. The minimum `vote_count` is exactly 100, consistent with the acquisition filter, and all ratings are inside the valid `[0,10]` range.

**Extreme but plausible.**  
`vote_count` reaches 12616 and `popularity` reaches 107.04. These values are far above their medians but are plausible for highly visible movies, so they are kept.

**Ambiguous** — The acquisition rule keeps at most six actors per movie. With 1208 movies, the theoretical maximum is `1208 × 6 = 7248` actor rows, while 7191 actor rows were collected. This gives 57 fewer actor rows than the maximum. This is not an error, because some TMDB movies may contain fewer than six cast entries.

**Shape.**  
`vote_count` is strongly right-skewed: the mean is 936.35 while the median is 378, and the maximum is 12616. The median therefore better represents a typical movie. `popularity` is also right-skewed, with mean 7.87, median 5.63 and maximum 107.04. `vote_average` is more centered, with mean 6.45 and median 6.44.

---

## 3. Temporal patterns

**Range covered:**  
The acquisition covers movie release dates from 2020 to 2025, consistent with the project scope. All six years are represented.

**Gaps:**  
No complete year is missing. The number of selected movies per year is:

- 2020: 211
- 2021: 225
- 2022: 225
- 2023: 202
- 2024: 176
- 2025: 169

All twelve calendar months are represented in the aggregated data. No complete monthly gaps were found between January 2020 and December 2025.

**Cycles:**  
The monthly distribution is not uniform. September has the highest number of selected releases with 143 movies, followed by October with 135, while May has the lowest count with 71. The annual counts are relatively stable from 2020 to 2022 and then decrease from 2023 to 2025.

**Timezone:**  
Not applicable. `release_date` contains calendar dates rather than timestamps with a time of day, so no timezone information is required for this analysis.

---

## 4. Representativeness

**Who or what is in this dataset?**  
The dataset contains TMDB movies with US origin, released from 2020 through 2025, classified as Drama or Thriller, and having at least 100 TMDB user votes. For each selected movie, the credits dataset contains at most the six highest-billed actors together with Directors, Producers and Directors of Photography.

**Who or what is missing?**  
The dataset excludes:

- movies outside 2020–2025;
- movies without US origin;
- movies that are neither Drama nor Thriller;
- movies with fewer than 100 votes;
- supporting actors beyond the top six billing positions;
- crew members with jobs outside Director, Producer and Director of Photography;
- movies or credits not available in TMDB.

**One conclusion this data cannot support.**  
“These collaboration patterns describe the entire US film industry.”

This would be incorrect because the dataset only represents the restricted TMDB sample defined by our acquisition criteria.

**Does more data fix it?**  
No. This is mainly a coverage / selection bias issue. Collecting more rows with the same filters would still exclude low-vote films, other genres, other time periods, actors outside the top six and other crew roles.

---

## 5. Final cleaning decisions

1. **Some credit fields are missing because they do not apply to that role. We kept these values missing and did not fill them or remove the rows.**

2. **Fourteen movies have fewer than six actors. TMDB does not always return six cast members, so we kept these movies and marked them with `cast_short_flag`.**

3. **Our dataset has a limited scope, so it does not represent all US films. We kept the original filters and described them as a limitation, not as a data error.**

4. **The cleaning notebook makes flagged copies of the raw files. The main fields added are `cast_short_flag` and `missing_reason`. We did not create a pipeline that automatically deletes rows.**

5. **The raw data was kept unchanged. We created clean copies with flags and explained why each decision was made.**

6. **We did not use a predictive model or target variable in this milestone, so train/test leakage does not apply here. We focused on data quality and keeping the cleaning process traceable.**