# Construct vector of zeroes

Make a numeric (double) vector of zeroes of at most length 2: contains
`+0` if the series contains `+0`, and contains `-0` if the series
contains `-0`. Internal; useful for delegating the behaviour of signed
zero to how R does it for numeric vectors.

## Usage

``` r
zeroes_vector(x)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

## Value

A numeric (double) vector of zeroes, either of length 0, 1, or 2.

## Examples

``` r
(none <- discretes:::zeroes_vector(natural1()))
#> integer(0)
1 / none
#> numeric(0)

(pos <- discretes:::zeroes_vector(integers()))
#> [1] 0
1 / pos
#> [1] Inf

(neg <- discretes:::zeroes_vector(arithmetic(-0, 1)))
#> [1] 0
1 / neg
#> [1] -Inf

(posneg <- discretes:::zeroes_vector(dsct_union(integers(), -0)))
#> [1] 0 0
1 / posneg
#> [1] -Inf  Inf
```
