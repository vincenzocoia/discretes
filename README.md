
<!-- README.md is generated from README.Rmd. Please edit that file -->

# discretes

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/probaverse/discretes/graph/badge.svg)](https://app.codecov.io/gh/probaverse/discretes)
[![R-CMD-check](https://github.com/probaverse/discretes/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/probaverse/discretes/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

While you can’t make an infinite-length vector in R like `1:Inf`, you
can get part-way there with discretes.

## Installation

You can install the development version of discretes like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Example

Base types of series:

- numeric
- arithmetic (and integers)
  - Difference being tolerance

Transformed series:

- linear
- negated
- inverted

## Similar Packages

- [‘Zseq’](https://cran.r-project.org/package=Zseq) provides access to
  various named integer sequences like the Fibonnaci sequence and Prime
  numbers, but does not allow the creation of new series by
  manipulation.
- [‘sets’]() package focusses on set operations.
- [‘set6’]() allows for infinite sets but was removed from CRAN.
- [‘peruse’](https://jacgoldsm.github.io/peruse/) provides tools for
  iterating a sequence like with `next_discrete()`. It focuses on fully
  general sequences without transformation.
