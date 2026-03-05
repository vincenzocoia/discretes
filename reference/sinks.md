# Sinks

Sinks are limit points in a numeric series. That means that discrete
values get arbitrarily close to the sink (from the left or right), and
there are infinitely many discrete values around the sink. This function
returns a matrix of all sinks in the numeric series.

## Usage

``` r
sinks(x)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

## Value

A matrix with two columns: `location` and `direction`. Each row
corresponds to a sink, where `location` is the location of the sink
(possibly infinite), and `direction` indicates whether the sink is
approached from the left (-1) or right (1).

## See also

[`has_sink_in()`](https://discretes.netlify.app/reference/has_sink.md),
[`has_sink_at()`](https://discretes.netlify.app/reference/has_sink.md)

## Examples

``` r
# The set of integers have sinks at +Inf and -Inf
sinks(integers())
#>      location direction
#> [1,]      Inf        -1
#> [2,]     -Inf         1

# The set 1, 1/2, 1/4, 1/8, ... has a sink at 0 approached from the right.
halves <- 0.5^natural0()
sinks(halves)
#>      location direction
#> [1,]        0         1

# The reciprocal of the integers has a sink at 0 approached from both the
# left and right; while the integer 0 gets mapped to Inf, infinity is not a
# sink because discrete values don't get arbitrarily close to it.
reciprocals <- 1 / integers()
sinks(reciprocals)
#>      location direction
#> [1,]        0         1
#> [2,]        0        -1
has_discretes(reciprocals, Inf) # Yet Inf is a discrete value.
#> [1] TRUE
```
