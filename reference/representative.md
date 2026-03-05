# Get a representative discrete value in a numeric series

Get a representative discrete value in a numeric series

## Usage

``` r
representative(x)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

## Value

A single numeric: a representative discrete value from the numeric
series, with the proper mode.

## Examples

``` r
representative(integers())
#> [1] 0
representative(natural1() + 7)
#> [1] 8
```
