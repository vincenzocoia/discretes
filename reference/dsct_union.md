# Combine numeric series

Combine one or more numeric series (or numeric vectors interpreted as
numeric series) into a single union, where each unique discrete value is
counted once.

## Usage

``` r
dsct_union(...)
```

## Arguments

- ...:

  Objects to combine. Each must be either a numeric series or a numeric
  vector.

## Value

A numeric series (inheriting from `dsct_union`).

## Details

Values are flattened

## Note

While both `-0` and `+0` can both exist,

## Examples

``` r
x1 <- natural1()
x2 <- -natural1()
dsct_union(x1, x2)
#> Union series of length Inf:
#> ..., -3, -2, -1, 1, 2, 3, ...
```
