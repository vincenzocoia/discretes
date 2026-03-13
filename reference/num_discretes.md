# Number of discrete values in a series

Return the number of discrete values in `x` that lie between `from` and
`to`, or test whether the number of discrete values is infinite.

## Usage

``` r
num_discretes(
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

- from, to:

  Reference values, possibly infinite. `from` must be less than or equal
  to `to`; both must be length-1 numeric vectors.

- ...:

  Reserved for future extensions; must be empty.

- include_from, include_to:

  Should the `from` value be included in the query? Should the `to`
  value? Both must be length-1 logical vectors.

- tol:

  Numerical tolerance when checking if a value is in the series. Single
  non-negative numeric. See
  [`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
  for details.

## Value

For `num_discretes()`, a single non-negative integer, or possibly `Inf`
for infinitely many discrete values.

## Examples

``` r
num_discretes(-3:3)
#> [1] 7
num_discretes(c(0.4, 0.4, 0.4, 0))
#> [1] 2

x <- arithmetic(-3.2, spacing = 0.5)
num_discretes(x)
#> [1] Inf
num_discretes(x, from = -2, to = 2)
#> [1] 8
num_discretes(1 / x, from = -2, to = 2)
#> [1] Inf
```
