# Extract discrete values from a numeric series

Extract a finite subset of discrete values from a numeric series by
asking for specific values (`get_discretes_at()`) or by setting a range
(`get_discretes_in()`). For `get_discretes_at()`, each value in `values`
is tested for membership using `tol` (passed down to the underlying
series); if it is a member, the corresponding discrete value is
returned, otherwise it is dropped. `NA` values are kept in place.

## Usage

``` r
get_discretes_at(x, values, ..., tol = sqrt(.Machine$double.eps))

get_discretes_in(
  x,
  from = -Inf,
  to = Inf,
  ...,
  include_from = TRUE,
  include_to = TRUE,
  tol = sqrt(.Machine$double.eps)
)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- values:

  Numeric vector of values to pull from the numeric series `x`.

- ...:

  Reserved for future extensions; must be empty.

- tol:

  Numerical tolerance when testing membership. Single non-negative
  numeric. See
  [`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
  for details.

- from, to:

  Reference values, possibly infinite. `from` must be less than or equal
  to `to`; both must be length-1 numeric vectors.

- include_from, include_to:

  Should the `from` value be included in the query? Should the `to`
  value? Both must be length-1 logical vectors.

## Value

A numeric vector containing all discrete values in the provided series
`x`:

- For `get_discretes_in()`, all discrete values between `from` and `to`,
  ordered from smallest to largest.

- For `get_discretes_at()`, the discrete values that the given `values`
  are members of. Membership is tested with `tol` at the underlying
  series, returning the discrete values in the series rather than the
  supplied `values`. Discrete values not within `tol` of the supplied
  `values` are dropped.

An error will be thrown in `get_discretes_in()` if there are infinitely
many points in the range.

## See also

[`as.double.discretes()`](https://discretes.netlify.app/reference/as.double.discretes.md)

## Examples

``` r
get_discretes_in(integers(), from = 6.6, to = 10.1)
#> [1]  7  8  9 10
get_discretes_in(1 / arithmetic(1, 4, n_left = 3, n_right = 5))
#> [1] -0.33333333 -0.14285714 -0.09090909  0.04761905  0.05882353  0.07692308
#> [7]  0.11111111  0.20000000  1.00000000
get_discretes_at(integers(), values = c(-10, 4, 3.5, 10, NA))
#> [1] -10   4  10  NA
get_discretes_at(integers(), values = 5.5)
#> integer(0)
```
