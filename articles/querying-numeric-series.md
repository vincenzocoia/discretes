# Querying a numeric series

``` r
library(discretes)
```

Once you have a numeric series, you can traverse it, test membership,
extract discrete values, and query limit points (sinks). This vignette
covers the main query functions.

## Traversing: `next_discrete()` and `prev_discrete()`

[`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
returns the next `n` discrete values in the series starting from a
reference point;
[`prev_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
does the same in the opposite direction. They are the main way to move
along a series without enumerating it.

``` r
x <- integers()
next_discrete(x, from = 10)
#> [1] 11
next_discrete(x, from = 10, n = 5)
#> [1] 11 12 13 14 15
prev_discrete(x, from = 1.3, n = 5)
#> [1]  1  0 -1 -2 -3
```

If `from` is itself a discrete value, you can include it by setting
`include_from = TRUE`. By default,
[`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
and
[`prev_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
use `include_from = FALSE`, so the result starts strictly after (or
before) `from`.

Traversal is delegated to the underlying series, and the result is
mapped back.

## Membership: `has_discretes()`

Use
[`has_discretes()`](https://discretes.netlify.app/reference/has_discretes.md)
to check whether given values are discrete values in the series. It
returns a logical vector, one per queried value.

``` r
has_discretes(natural1(), c(0, 1, 2, 2.5))
#> [1] FALSE  TRUE  TRUE FALSE
has_discretes(integers(), c(-10, 0, 10, NA))
#> [1] TRUE TRUE TRUE   NA
```

`NA` in the queried values yields `NA` in the result.

## Getting discrete values: `get_discretes_at()` and `get_discretes_in()`

**[`get_discretes_at()`](https://discretes.netlify.app/reference/get_discretes.md)**
— Grabs the specified discrete values that are members of the series
(within `tol` of the base series), the corresponding discrete value in
the series is returned; otherwise it is dropped. So the result is the
“canonical” discrete values at those positions. `NA` values are kept in
place.

``` r
get_discretes_at(integers(), values = c(-10, 4, 3.5, 10, NA))
#> [1] -10   4  10  NA
get_discretes_at(integers(), values = 5.5)
#> integer(0)
```

**[`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md)**
— Returns all discrete values within a range. The result is ordered from
smallest to largest. If there are infinitely many discrete values in the
range,
[`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md)
throws an error; use
[`num_discretes()`](https://discretes.netlify.app/reference/num_discretes.md)
first to check.

``` r
get_discretes_in(integers(), from = 6.6, to = 10.1)
#> [1]  7  8  9 10
get_discretes_in(1 / arithmetic(1, 4, n_left = 3, n_right = 5))
#> Loading required namespace: testthat
#> [1] -0.33333333 -0.14285714 -0.09090909  0.04761905  0.05882353  0.07692308
#> [7]  0.11111111  0.20000000  1.00000000
```

## Counting: `num_discretes()`

[`num_discretes()`](https://discretes.netlify.app/reference/num_discretes.md)
returns how many discrete values lie in a range. It can return `Inf` for
infinite series.

``` r
num_discretes(integers(), from = -2, to = 5)
#> [1] 8
num_discretes(1 / 2^integers(), from = 0, to = 1)
#> [1] Inf
```

## Querying sinks

A **sink** is a limit point of a numeric series: discrete values get
arbitrarily close to it, and there are infinitely many discrete values
near the sink.

[`sinks()`](https://discretes.netlify.app/reference/sinks.md) lists all
sinks in a matrix of locations and directions: approached from the left
(-1) or right (+1).

``` r
sinks(integers())
#>      location direction
#> [1,]      Inf        -1
#> [2,]     -Inf         1
sinks(0.5^natural0())
#>      location direction
#> [1,]        0         1
reciprocals <- 1 / integers()
sinks(reciprocals)
#>      location direction
#> [1,]        0         1
#> [2,]        0        -1
```

[`has_sink_in()`](https://discretes.netlify.app/reference/has_sink.md)
or
[`has_sink_at()`](https://discretes.netlify.app/reference/has_sink.md)
are convenience functions that test for a sink in an interval or at a
value.

``` r
has_sink_in(integers())
#> [1] TRUE
has_sink_at(integers(), Inf)
#> [1] TRUE
has_sink_at(integers(), -Inf, dir = "right")
#> [1] TRUE
```

For
[`has_sink_at()`](https://discretes.netlify.app/reference/has_sink.md),
`dir` can be `"either"` (any direction), `"left"` or `"right"` (sink
approached from that side), or `"both"` (approached from both sides).
When a series has a sink, there is no “next” or “previous” discrete
value on the far side of the sink
(e.g. `next_discrete(reciprocals, from = -1)` returns nothing).

Together, the functions above cover traversing, membership, extraction,
counting, and sink queries for any numeric series.
