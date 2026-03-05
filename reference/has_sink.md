# Test for sinks in a numeric series

`has_sink_in()` tests whether a numeric series has a sink in the
interval `[from, to]`. `has_sink_at()` tests whether there is a sink at
a given value, optionally with a specific direction.

## Usage

``` r
has_sink_in(x, from = -Inf, to = Inf)

has_sink_at(x, value, dir = c("either", "left", "right", "both"))
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- from, to:

  Reference values, possibly infinite. `from` must be less than or equal
  to `to`; both must be length-1 numeric vectors.

- value:

  Single numeric to check for the existence of a sink.

- dir:

  Single character: direction of the sink. `"either"` (default) ignores
  direction; `"left"` or `"right"` require the sink to be approached
  from that side; `"both"` requires it to be approached from both sides.

## Value

A length-one logical: `TRUE` if a sink exists in the range
(`has_sink_in`) or at `value` with the given `dir` (`has_sink_at`);
`FALSE` otherwise.

## See also

See [`sinks()`](https://discretes.netlify.app/reference/sinks.md) to get
all sinks, and a description of sinks.

## Examples

``` r
# The set of integers have sinks at +Inf and -Inf
has_sink_in(integers())
#> [1] TRUE
has_sink_at(integers(), Inf)
#> [1] TRUE
has_sink_at(integers(), -Inf, dir = "right")
#> [1] TRUE

# The set 1, 1/2, 1/4, 1/8, ... has a sink at 0 approached from the right.
halves <- 0.5^natural0()
has_sink_in(halves, to = 0)
#> [1] FALSE
has_sink_at(halves, 0, dir = "right")
#> [1] TRUE

# Reciprocal of integers: sink at 0 from both sides
reciprocals <- 1 / integers()
has_sink_at(reciprocals, 0, dir = "both")
#> [1] TRUE
```
