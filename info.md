## 1. First inspection

### Movies

- Shape: 1208 rows × 9 columns.
- No missing values were found in the retained movie fields.
- The minimum `vote_count` is 100, consistent with the acquisition filter.
- `vote_count` is strongly right-skewed:
  mean = 936.35, median = 378, maximum = 12616.
- `popularity` is also right-skewed:
  mean = 7.87, median = 5.63, maximum = 107.04.
- `vote_average` is more centered:
  mean = 6.45 and median = 6.44.

### Credits

- Shape: 14252 rows × 7 columns.
- Role counts:
  - actor: 7191
  - producer: 4573
  - director: 1289
  - cinematographer: 1199
- `department` and `job` each have 7191 missing values,
  exactly equal to the number of actor rows.
- `billing_order` has 7061 missing values,
  exactly equal to the number of non-actor rows.
- This suggests that the missing values are structural and depend on the role.
- There are fewer than six actor rows per movie on average maximum:
  7191 actor rows versus 7248 expected if every movie had six actors.