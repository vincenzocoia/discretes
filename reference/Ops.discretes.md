# Arithmetic and power operators for numeric series

Support for `+`, `-`, `*`, `/`, and `^` between a numeric series and a
single number. One operand must be a numeric series and the other a
number.

## Usage

``` r
# S3 method for class 'discretes'
Ops(e1, e2)
```

## Arguments

- e1, e2:

  Operands; one must be a numeric series (class `discretes`), the other
  a single numeric.

## Value

A numeric series resulting from the operation (e.g. series + number,
number \* series, series^number).

## Examples

``` r
integers() + 1
#> Linear-transformed series of length Inf:
#> ..., -1, 0, 1, 2, 3, 4, ...
2 * natural1()
#> Linear-transformed series of length Inf:
#> 2, 4, 6, 8, 10, 12, ...
1 / integers(from = 1, to = 5)
#> Reciprocal series of length 5:
#> Loading required namespace: testthat
#> 0.2, 0.25, 0.3333333, 0.5, 1
natural0()^2
#> Transformed series of length Inf:
#> 0, 1, 4, 9, 16, 25, ...
```
