# Exponentiation of a numeric series

Exponentiate a numeric series `x` with a given base; that is, `base^x`.
`dsct_exp()` is a special case of `dsct_raise()` where the base is
`exp(1)`. Internal; use [`exp()`](https://rdrr.io/r/base/Log.html) or
`^` operators instead.

## Usage

``` r
dsct_raise(x, base = exp(1))

dsct_exp(x)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- base:

  The base to use for exponentiation; numeric of length 0 or 1, with
  negative values not allowed (an error is thrown otherwise).

## Value

A numeric series whose discrete values are the result of exponentiating
each discrete value of `x` by `base` (that is, `base^x`).

## Examples

``` r
# These are the same
discretes:::dsct_exp(integers())
#> Transformed series of length Inf:
#> ..., 0.1353353, 0.3678794, 1, 2.718282, 7.389056, 20.08554, ...
discretes:::dsct_raise(integers(), base = exp(1))
#> Transformed series of length Inf:
#> ..., 0.1353353, 0.3678794, 1, 2.718282, 7.389056, 20.08554, ...
exp(integers())
#> Transformed series of length Inf:
#> ..., 0.1353353, 0.3678794, 1, 2.718282, 7.389056, 20.08554, ...

# These are also the same
discretes:::dsct_raise(integers(), base = 2)
#> Transformed series of length Inf:
#> ..., 0.25, 0.5, 1, 2, 4, 8, ...
2^integers()
#> Transformed series of length Inf:
#> ..., 0.25, 0.5, 1, 2, 4, 8, ...

# This also works. Notice how the set reduces.
0^integers()
#> Numeric vector series of length 3:
#> 0, 1, Inf
```
