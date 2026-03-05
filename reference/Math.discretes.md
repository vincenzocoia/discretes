# Math group generic for numeric series

Support for `exp`, `log`, `log10`, `log2`, and `sqrt` on numeric series.
The new series behaves as though the function is applied to each
discrete value in the series.

## Usage

``` r
# S3 method for class 'discretes'
Math(x, ...)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- ...:

  Passed to [`log()`](https://rdrr.io/r/base/Log.html) for the `base`
  argument when `op == "log"`.

## Value

A numeric series with the math function applied.

## Examples

``` r
exp(integers(from = 0, to = 3))
#> Transformed series of length 4:
#> 1, 2.718282, 7.389056, 20.08554
log(natural1())
#> Transformed series of length Inf:
#> 0, 0.6931472, 1.098612, 1.386294, 1.609438, 1.791759, ...
sqrt(integers(from = 0, to = 10))
#> Transformed series of length 11:
#> 0, 1, 1.414214, ..., 2.828427, 3, 3.162278
```
