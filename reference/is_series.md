# Check if an object is treated as a numeric series

Returns `TRUE` if an object inherits the class `"discretes"` or is a
numeric vector.

## Usage

``` r
is_series(x)
```

## Arguments

- x:

  Object to check.

## Value

`TRUE` if `x` is treated as a numeric series, `FALSE` otherwise.

## Examples

``` r
is_series(natural0())
#> [1] TRUE
is_series(c(1, 2, 3))
#> [1] TRUE
is_series("not a numeric series")
#> [1] FALSE
```
