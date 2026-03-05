# Raise a numeric series to a power

Apply a power transformation to a numeric series `x` for a given
`power`; that is, `x^power`. Internal; use `^` operator instead.

## Usage

``` r
dsct_power(x, power)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- power:

  The power to raise the series to; numeric of length 0 or 1. If `x`
  contains negative discrete values, then `power` must be an integer,
  otherwise an error is thrown because the result would contain complex
  numbers, which are not supported.

## Value

A numeric series whose discrete values are the result of applying the
power transformation `^` to the discrete values of `x` with the
specified `power`.

## Examples

``` r
## These are the same
discretes:::dsct_power(natural0(), power = 2)
#> Transformed series of length Inf:
#> 0, 1, 4, 9, 16, 25, ...
natural0()^2
#> Transformed series of length Inf:
#> 0, 1, 4, 9, 16, 25, ...

## These are also the same
discretes:::dsct_power(integers(), power = 3)
#> Transformed series of length Inf:
#> ..., -8, -1, 0, 1, 8, 27, ...
integers()^3
#> Transformed series of length Inf:
#> ..., -8, -1, 0, 1, 8, 27, ...
```
