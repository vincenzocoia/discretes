# Integer numeric series

Use `integers()` to create a numeric series whose discrete values are
integers within a specified range, possibly unbounded on either end. Use
`natural0()` and `natural1()` for the natural numbers starting at 0 or
1.

## Usage

``` r
integers(from = -Inf, to = Inf)

natural1()

natural0()
```

## Arguments

- from, to:

  Numeric values defining the range of integers. Defaults to `-Inf` and
  `Inf`, representing all integers; the series is not closed, so `-Inf`
  and `Inf` are never discrete values.

## Value

A numeric series (arithmetic, class `"dsct_arithmetic"`) whose discrete
values are the integers in the specified range.

## See also

[`arithmetic()`](https://discretes.netlify.app/reference/arithmetic.md)

## Examples

``` r
integers()                  # All integers
#> Integer series of length Inf:
#> ..., -2, -1, 0, 1, 2, 3, ...
integers(from = 0)          # Non-negative integers
#> Integer series of length Inf:
#> 0, 1, 2, 3, 4, 5, ...
integers(to = 1.5)          # Ends at 1.
#> Integer series of length Inf:
#> ..., -4, -3, -2, -1, 0, 1
integers(-5, 5) # Integers from -5 to 5.
#> Integer series of length 11:
#> -5, -4, -3, ..., 3, 4, 5
natural1()
#> Integer series of length Inf:
#> 1, 2, 3, 4, 5, 6, ...
natural0()
#> Integer series of length Inf:
#> 0, 1, 2, 3, 4, 5, ...

# Infinity is never contained in the series.
has_discretes(integers(), Inf)
#> [1] FALSE
```
