# Querying a numeric series

``` r
library(discretes)
```

Once you have a numeric series, you can materialize it as a numeric
vector, check which values are in it, count values in a range, and query
limit points (sinks). This vignette covers these query functions.

## Materializing values from a series

Materializing a series means producing its discrete values as an
ordinary numeric vector. There are three ways to do it.

### Traversing: `next_discrete()` and `prev_discrete()`

[`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
returns the next `n` discrete values in the series starting from a
reference point;
[`prev_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
does the same in the opposite direction. They return a numeric vector of
values (of length at most `n`).

``` r
x <- integers()
next_discrete(x, from = 10)
#> [1] 11
next_discrete(x, from = 10, n = 5, include_from = TRUE)
#> [1] 10 11 12 13 14
prev_discrete(x, from = 1.3, n = 5)
#> [1]  1  0 -1 -2 -3
```

When `x` is a modified series, traversal is delegated to the underlying
series, and the result is mapped back.

### Pulling values: `get_discretes_at()` and `get_discretes_in()`

Rather than traversing from a reference point, you can ask for values in
a range or at specific values.

**[`get_discretes_at()`](https://discretes.netlify.app/reference/get_discretes.md)**
— Gets specified discrete values from the series, if they can be found
in the series (within `tol` of the base series).

``` r
get_discretes_at(integers(), values = c(-10, 4, 3.5, 10, NA))
#> [1] -10   4  10  NA
get_discretes_at(integers(), values = 5.5)
#> integer(0)
```

**[`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md)**
— Gets all discrete values within a range. The result is ordered from
smallest to largest. If there are infinitely many discrete values in the
range,
[`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md)
throws an error; use
[`num_discretes()`](https://discretes.netlify.app/reference/num_discretes.md)
first to check.

``` r
get_discretes_in(integers(), from = 6.6, to = 10.1)
#> [1]  7  8  9 10
get_discretes_in(1 / integers(0, 5))
#> Loading required namespace: testthat
#> [1] 0.2000000 0.2500000 0.3333333 0.5000000 1.0000000       Inf
```

### Subsetting by position: `[`

When a series has a well-defined first element
(e.g. [`natural1()`](https://discretes.netlify.app/reference/integers.md)),
you can subset by position with `[`.

``` r
natural1()[2]
#> [1] 2
natural1()[c(1, 3, 5)]
#> [1] 1 3 5
```

Unlike
[`dsct_keep()`](https://discretes.netlify.app/reference/subsetting.md)
and
[`dsct_drop()`](https://discretes.netlify.app/reference/subsetting.md),
which return a *new series*, `[` materializes the series as a numeric
vector.

The behaviour of subsetting is delegated to base R, so you can expect
similar behaviour:

``` r
x <- as_discretes(1:4)
x[-1]
#> [1] 2 3 4
x[c(0, NA, 1, 4, 1, 5)]
#> [1] NA  1  4  1 NA
x[]
#> [1] 1 2 3 4
```

However, note that assignment via `[` is not supported.

## Counting: `num_discretes()`

[`num_discretes()`](https://discretes.netlify.app/reference/num_discretes.md)
returns how many discrete values lie in a range. It returns `Inf` for
infinite-length series.

``` r
num_discretes(integers(), from = -2, to = 5)
#> [1] 8
num_discretes(1 / 2^integers(), from = 0, to = 1)
#> [1] Inf
```

## Which values are in the series?

Use
[`has_discretes()`](https://discretes.netlify.app/reference/has_discretes.md)
to check whether given values are in the series. It returns a logical
vector, one per queried value.

``` r
has_discretes(natural1(), c(0, 1, 2, 2.5))
#> [1] FALSE  TRUE  TRUE FALSE
has_discretes(integers(), c(-10, 0, 10, NA))
#> [1] TRUE TRUE TRUE   NA
```

`NA` in the queried values yields `NA` in the result.

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
