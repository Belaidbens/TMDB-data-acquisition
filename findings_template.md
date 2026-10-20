# EDA findings — <dataset name>

**Pair:** <name>, <name> · **Dataset:** <source and scope> · **Date:** <date>
**Rows × columns:** <n> × <n> · **File:** <path and format>

Fill in every section. **Each answer can be a number and a sentence**: what you measured, and what you will do about it. "No
problem found" is a valid answer.

Keep the headings exactly as they are.

---

## 1. Missingness

**Which columns, and how much?**

| Column | Missing | % | Sentinel |
| --- | ---: | ---: | --- |
|  |  |  |  |

**Do they go missing together?** <Which columns share the same rows, and how
many rows is that?>

**What is the mechanism?** <Which other column predicts the gap, or "not
found". Name the real-world cause if you can identify it.>

**MCAR, MAR or MNAR, and how do you know?** <If you cannot tell from the data alone, say so and say what you
would need.>

**Decision.** <Drop / keep / impute / model separately.
Give what changes: median, row count, removed categories.>

---

## 2. Distributions and outliers

**Per numeric column of interest:**

| Column | min | median | max | Impossible values | Ambiguous values |
| --- | ---: | ---: | ---: | ---: | ---: |
|  |  |  |  |  |  |

**Impossible** — violates the constraints of the data (a negative duration).
<How many, in which columns, and what you intend to do with them.>

**Extreme but plausible**. <How many, and why you are
keeping them.>

**Ambiguous** — cannot be resolved from the file alone (a zero-distance
trip). <How many, what are the possible explanations, and which do you choose.>

**Shape.** <Is it skewed? Which way? Does the mean or the median describe a
typical value here, and how do they differ?>

---

## 3. Temporal patterns

**Range covered:** <First and last timestamp, and whether that makes sense.>

**Gaps:** <Any period with no rows, or suspiciously few. Give the dates.>

**Cycles:** <Hour-of-day, day-of-week or seasonal structure you can see, in
one sentence each.>

**Timezone:** <Naive or aware? Which zone are the timestamps in, and how do
you know? If the file does not say, say that.>

---

## 4. Representativeness

**Who or what is in this dataset?** <The population the rows actually
describe.>

**Who or what is missing?** <The groups this data does not cover. Be specific.>

**One conclusion this data cannot support.** <Write a "tempting" sentence
that would be wrong.>

**Does more data fix it?** <Usually no, say what the issue is: sampling/coverage.>

---

## 5. What you need to do next

Ranked list, most important first. Each line: **what is wrong - what you
will do - what is the consequence / cost.**

1.
2.
3.
