# Subset a numeric series

Subset a numeric series

## Usage

``` r
dsct_drop(
  x,
  from = -Inf,
  to = Inf,
  ...,
  include_from = TRUE,
  include_to = TRUE
)

dsct_keep(
  x,
  from = -Inf,
  to = Inf,
  ...,
  include_from = TRUE,
  include_to = TRUE
)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- from, to:

  Numeric values defining the range to keep; single numerics with
  `from <= to`.

- ...:

  Reserved for future extensions; must be empty.

- include_from, include_to:

  Logical values indicating whether the `from` and `to` values should be
  included in the kept range; single logicals.

## Value

A numeric series representing the subset of discrete values within the
specified range.

## Examples

``` r
x <- integers(from = -3)
dsct_keep(x, from = -1.5, to = 2.5)
#> Subset series of length 4:
#> -1, 0, 1, 2
dsct_keep(x, to = 2)
#> Subset series of length 6:
#> -3, -2, -1, 0, 1, 2
```
