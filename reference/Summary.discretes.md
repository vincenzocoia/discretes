# Summary group generic for numeric series

Support for [`min()`](https://rdrr.io/r/base/Extremes.html),
[`max()`](https://rdrr.io/r/base/Extremes.html),
[`range()`](https://rdrr.io/r/base/range.html),
[`sum()`](https://rdrr.io/r/base/sum.html), and
[`prod()`](https://rdrr.io/r/base/prod.html) on numeric series.
[`min()`](https://rdrr.io/r/base/Extremes.html),
[`max()`](https://rdrr.io/r/base/Extremes.html), and
[`range()`](https://rdrr.io/r/base/range.html) report the smallest and
largest values that bound the series: the extreme discrete values,
together with any
[`sinks()`](https://discretes.netlify.app/reference/sinks.md) (limit
points) the discrete values approach.
[`sum()`](https://rdrr.io/r/base/sum.html) and
[`prod()`](https://rdrr.io/r/base/prod.html) are only defined for series
with finitely many discrete values.

## Usage

``` r
# S3 method for class 'discretes'
Summary(x, ..., na.rm = FALSE)
```

## Arguments

- x, ...:

  Numeric series and/or numeric vectors to summarise.

- na.rm:

  Single logical; passed to the underlying summary function when
  combining values.

## Value

A numeric vector: length 2 for
[`range()`](https://rdrr.io/r/base/range.html), length 1 otherwise.

## Details

[`min()`](https://rdrr.io/r/base/Extremes.html) and
[`max()`](https://rdrr.io/r/base/Extremes.html) return the infimum and
supremum of the discrete values. For an unbounded series these are
`-Inf` and `Inf`; for a series whose values pile up against a finite
sink (e.g. `1 / natural1()` approaching `0`), the sink is the relevant
bound even though it is not itself a discrete value.

[`all()`](https://rdrr.io/r/base/all.html) and
[`any()`](https://rdrr.io/r/base/any.html) are not defined for numeric
series, and [`sum()`](https://rdrr.io/r/base/sum.html) and
[`prod()`](https://rdrr.io/r/base/prod.html) throw an error when the
series has infinitely many discrete values.

## Examples

``` r
range(natural1())          # 1 Inf
#> [1]   1 Inf
min(integers(5, 10))       # 5
#> [1] 5
max(1 / natural1())        # 1
#> [1] 1
range(1 / natural1())      # 0 1  (sink at 0 bounds the series below)
#> [1] 0 1
sum(integers(1, 100))      # 5050
#> [1] 5050
```
