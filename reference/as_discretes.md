# Create a numeric series from a numeric vector

Create a numeric series from a numeric vector

## Usage

``` r
as_discretes(x)
```

## Arguments

- x:

  A numeric vector with no missing values. May contain infinity.

## Value

A numeric series (object of class `"discretes"`) whose discrete values
are the unique values of `x`.

## Examples

``` r
as_discretes(0:10)
#> Numeric vector series of length 11:
#> 0, 1, 2, ..., 8, 9, 10
```
