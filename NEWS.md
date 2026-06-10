# discretes 0.1.1

* Added a `Summary` group generic method so that `range()`, `min()`, `max()`,
  `sum()`, and `prod()` work on numeric series. Previously these fell through to
  base R defaults and operated on the internal representation; e.g.
  `range(natural1())` wrongly returned `c(0, Inf)` instead of `c(1, Inf)`.
* `dsct_transform()` now warns when the declared `range` is wider than the
  function's image.
* `num_discretes()` now returns `0` with a warning when `to < from` (an empty
  range), consistently across all series types, rather than erroring. This acts
  as a guard when `dsct_transform()` specifies a function `range` that is wider
  than the mapped `domain`.

# discretes 0.1.0

* Initial CRAN submission.
