# Logarithm of a numeric series

Apply a logarithmic transformation to a numeric series for a given
`base`. `dsct_ln()` is the natural logarithm that uses base `exp(1)`.
Internal; use [`log()`](https://rdrr.io/r/base/Log.html) instead.

## Usage

``` r
dsct_log(x, base = exp(1))
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- base:

  The base to use for the logarithm; numeric of length 0 or 1, with
  negative values and 1 not allowed (an error is thrown otherwise).

## Value

A numeric series whose discrete values are the result of applying the
logarithmic transformation [`log()`](https://rdrr.io/r/base/Log.html) to
the discrete values of `x` with the specified base.

## Examples

``` r
## These are the same
discretes:::dsct_log(natural0(), base = exp(1))
#> Transformed series of length Inf:
#> -Inf, 0, 0.6931472, 1.098612, 1.386294, 1.609438, ...
log(natural0())
#> Transformed series of length Inf:
#> -Inf, 0, 0.6931472, 1.098612, 1.386294, 1.609438, ...

## These are also the same
discretes:::dsct_log(natural0(), base = 10)
#> Transformed series of length Inf:
#> -Inf, 0, 0.30103, 0.4771213, 0.60206, 0.69897, ...
log(natural0(), base = 10)
#> Transformed series of length Inf:
#> -Inf, 0, 0.30103, 0.4771213, 0.60206, 0.69897, ...
log10(natural0())
#> Transformed series of length Inf:
#> -Inf, 0, 0.30103, 0.4771213, 0.60206, 0.69897, ...
```
