# Convert a numeric series to a numeric vector

Return all discrete values in the numeric series, if finite. Throws an
error if infinite.

## Usage

``` r
# S3 method for class 'discretes'
as.double(x, ...)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- ...:

  Arguments to pass downstream to
  [`as.numeric()`](https://rdrr.io/r/base/numeric.html) that's called on
  the resulting vector of discrete values.

## Value

A numeric vector containing all discrete values in `x`, ordered from
smallest to largest. Returns `numeric(0)` when the interval contains no
discrete values. Numeric outputs are wrapped in
[`as.numeric()`](https://rdrr.io/r/base/numeric.html).

## See also

[`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md)

## Examples

``` r
as.numeric(integers(-3.5, 10))
#>  [1] -3 -2 -1  0  1  2  3  4  5  6  7  8  9 10
```
