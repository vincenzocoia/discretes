# Check if values are between two bounds

This function checks if each element of a numeric vector `x` lies within
the specified lower and upper bounds. You can choose whether each end is
open or closed.

## Usage

``` r
is_between(x, lower, upper, include_lower = TRUE, include_upper = TRUE)
```

## Arguments

- x:

  A numeric vector to be checked.

- lower, upper:

  Single numeric values specifying the lower and upper bounds.

- include_lower, include_upper:

  Single logical values indicating whether the lower and upper bounds
  are inclusive (closed, `TRUE`, the default) or exclusive (open,
  `FALSE`).

## Value

A logical vector of the same length as `x`, with `TRUE` for elements
that lie within the specified bounds and `FALSE` otherwise. `NA` inputs
are propagated to the output.

## Details

The convention is adopted that, if `lower` and `upper` are equal, both
ends of the interval must be closed in order for any value to be
considered between them; otherwise, `FALSE` will be returned.

## Examples

``` r
discretes:::is_between(1:5, lower = 2, upper = 2)
#> [1] FALSE  TRUE FALSE FALSE FALSE
discretes:::is_between(1:5, lower = 2, upper = 2, include_lower = FALSE)
#> [1] FALSE FALSE FALSE FALSE FALSE
discretes:::is_between(1:5, lower = 2, upper = 4, include_upper = FALSE)
#> [1] FALSE  TRUE  TRUE FALSE FALSE
```
