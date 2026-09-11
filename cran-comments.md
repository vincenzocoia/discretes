## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a patch release. `range()`, `min()`, `max()`, `sum()` and `prod()`
  on a numeric series fell through to base R and silently gave wrong answers;
  this release adds the missing method, along with two smaller fixes listed in
  NEWS.md.

Checked with `R CMD check --as-cran` locally (macOS, R 4.6.0), and on GitHub
Actions (macOS, Windows and Ubuntu on R release; Ubuntu on R devel and
oldrel-1).

## Reverse dependencies

There are currently no reverse dependencies on CRAN.
