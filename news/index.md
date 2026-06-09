# Changelog

## discretes 0.1.1

- Added a `Summary` group generic method so that
  [`range()`](https://rdrr.io/r/base/range.html),
  [`min()`](https://rdrr.io/r/base/Extremes.html),
  [`max()`](https://rdrr.io/r/base/Extremes.html),
  [`sum()`](https://rdrr.io/r/base/sum.html), and
  [`prod()`](https://rdrr.io/r/base/prod.html) work on numeric series.
  Previously these fell through to base R defaults and operated on the
  internal representation; e.g. `range(natural1())` wrongly returned
  `c(0, Inf)` instead of `c(1, Inf)`.

## discretes 0.1.0

CRAN release: 2026-03-31

- Initial CRAN submission.
