# Create an empty numeric series

Create a numeric series with no discrete values.

## Usage

``` r
empty_series(mode = c("double", "integer"))
```

## Arguments

- mode:

  Character vector of length 1 indicating the numeric type of the
  numeric series; either "double" (the default) or "integer".

## Value

An empty numeric series of the specified mode.

## Examples

``` r
empty_series()
#> Empty series.
```
