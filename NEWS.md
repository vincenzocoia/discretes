# discretes 0.1.0

* Initial CRAN submission.
* Added a `Summary` group generic method so that `range()`, `min()`, `max()`,
  `sum()`, and `prod()` work on numeric series. Previously these fell through to
  base R defaults and operated on the internal representation; e.g.
  `range(natural1())` wrongly returned `c(0, Inf)` instead of `c(1, Inf)`.
