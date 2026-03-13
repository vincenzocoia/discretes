# Subset a numeric series by position

When a series has a well-defined "first" element (e.g.
[`natural1()`](https://discretes.netlify.app/reference/integers.md)
starts at 1), subsetting with `[]` materializes a specified part of the
series, and mirrors the behaviour of base R. Positive `i` returns the
discrete values at those positions, and negative `i` tries to return the
full series with the specified positions dropped.

## Usage

``` r
# S3 method for class 'discretes'
x[i]

# S3 method for class 'discretes'
x[i] <- value
```

## Arguments

- x:

  A numeric series (object of class `"discretes"`).

- i:

  Numeric vector of indices. Omit for the full series (finite only).

- value:

  Replacement value; ignored, because replacement via `[<-` is not
  supported.

## Value

A vector of discrete values. When the series has no first element or too
few values for positive `i`, R returns NA as for ordinary vectors. For
negative `i` or missing `i`, the full series is obtained first; infinite
series behaviour defaults to that of
[`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md).

## Details

Subsetting via `[]` tries to delegate to base R as quickly as possible
by first materializing the series as a vector, and then conducting the
subsetting.

- If `i` is missing or has negative values, subsetting is delegated to
  the full series materialized via
  [`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md)
  (if possible).

- If `i` is `NULL` or length-0, subsetting is delegated to a
  representative value of the series.

- If `i` doesn't have negative values, subsetting is delegated to the
  series materialized as far out as needed to cover all `i`s, via
  [`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md)
  from `-Inf`.

## Note

Unlike base R, the following actions are not supported:

- Replacement via `[<-` (throws an error).

- Subsetting by a character vector, as though subsetting by entry names.

- Subsetting by a logical vector.

## Examples

``` r
natural1()[2]
#> [1] 2
natural1()[c(1, 3, 5)]
#> [1] 1 3 5
integers(1, 5)[-1]   # full series with first value dropped
#> [1] 2 3 4 5

# Subsetting from the other side of a sink
x <- 1 / natural1()
x[1:3]   # No such thing as a "first" value; returns NA.
#> [1] NA NA NA
y <- dsct_union(x, -1)
y[1:3]   # "-1" is the 1st value, but no such thing as 2nd or 3rd value.
#> [1] -1 NA NA
```
