# Linearly transform a numeric series

Apply a linear function to a numeric series (`m * x + b`). Internal
function; prefer using `+`, `-`, `*`, and `/` instead.

## Usage

``` r
dsct_linear(x, m, b = NULL)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- m:

  A numeric value indicating the multiplier.

- b:

  A numeric value indicating the intercept. Allowed to be `NULL` (the
  default) to indicate the transformation `m * x` without an intercept,
  which is important to distinguish signed zero.

## Value

A numeric series with the linear transformation applied.

## Examples

``` r
discretes:::dsct_linear(integers(), m = 2)
#> Linear-transformed series of length Inf:
#> ..., -4, -2, 0, 2, 4, 6, ...
discretes:::dsct_linear(integers(), m = 2, b = 0.5)
#> Linear-transformed series of length Inf:
#> ..., -3.5, -1.5, 0.5, 2.5, 4.5, 6.5, ...
```
