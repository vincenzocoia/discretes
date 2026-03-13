# Check which values are in a numeric series

Check which values are in a numeric series

## Usage

``` r
has_discretes(x, values, ..., tol = sqrt(.Machine$double.eps))
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- values:

  A vector of values to check.

- ...:

  Reserved for future extensions; must be empty.

- tol:

  Numerical tolerance when checking if a value is in the series. Single
  non-negative numeric. See
  [`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
  for details.

## Value

A logical vector indicating whether each value is in the numeric series
`x`. `NA` values are preserved such that `NA` in `values` results in
`NA` in the output.

## Note

This function does not distinguish between `+0` and `-0`. For that, use
[`has_negative_zero()`](https://discretes.netlify.app/reference/negative_zero.md)
or
[`has_positive_zero()`](https://discretes.netlify.app/reference/negative_zero.md).

## Examples

``` r
has_discretes(natural0(), c(-1, 0, 1, 12.5, NA))
#> [1] FALSE  TRUE  TRUE FALSE    NA
has_discretes(1 / natural1(), 0)
#> [1] FALSE
```
