# Monotonically transform a numeric series

Apply a function that is strictly increasing or strictly decreasing to a
numeric series.

## Usage

``` r
dsct_transform(x, fun, ...)

# S3 method for class 'discretes'
dsct_transform(
  x,
  fun,
  inv,
  ...,
  domain = c(-Inf, Inf),
  range = c(-Inf, Inf),
  dir = c("increasing", "decreasing")
)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- fun, inv:

  A vectorized, strictly monotonic function to apply to the discrete
  values, and its inverse, `inv`.

- ...:

  Arguments to pass to specific methods.

- domain, range:

  Numeric vectors of length 2, indicating the domain and range of `fun`
  (that is, the interval on which `fun` is valid, and the interval to
  which `fun` maps).

- dir:

  A string, either "increasing" or "decreasing", indicating the
  monotonicity of the function `fun`.

## Value

A numeric series with the transformation applied.

## Details

Strictly increasing means that for any `x1 < x2`, it holds that
`fun(x1) < fun(x2)`, for all values on the real line. The function
`-1/x`, for example, is not strictly increasing: its derivative is
increasing, but switches to smaller values after `x = 0`, therefore is
not strictly increasing. Strictly decreasing is the opposite, in that we
have `fun(x1) > fun(x2)`.

If a decreasing function is provided, the transformation is negated
internally first, and then transformed with fun(-x).

## Examples

``` r
dsct_transform(integers(), fun = pnorm, inv = qnorm, range = c(0, 1))
#> Transformed series of length Inf:
#> ..., 0.02275013, 0.1586553, 0.5, 0.8413447, 0.9772499, 0.9986501, ...
dsct_transform(
  as_discretes(0:3),
  fun = cos,
  inv = acos,
  domain = c(0, pi),
  range = c(-1, 1),
  dir = "decreasing"
)
#> Transformed series of length 4:
#> -0.9899925, -0.4161468, 0.5403023, 1

# For numeric inputs, function is applied directly.
# Other arguments beyond `fun` get absorbed in `...` and are not used.
dsct_transform(0:5, exp)
#> [1]   1.000000   2.718282   7.389056  20.085537  54.598150 148.413159
dsct_transform(0:5, exp, log)
#> [1]   1.000000   2.718282   7.389056  20.085537  54.598150 148.413159
```
