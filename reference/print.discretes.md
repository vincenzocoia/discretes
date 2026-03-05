# Print a numeric series

Print a numeric series to the console.

## Usage

``` r
# S3 method for class 'discretes'
print(x, len = 6, ...)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

- len:

  Number of discrete values to display.

- ...:

  Further arguments to pass to downstream methods; currently not used.

## Value

Invisibly returns the input object `x`.

## Examples

``` r
print(integers())
#> Integer series of length Inf:
#> ..., -2, -1, 0, 1, 2, 3, ...
print(1 / natural1())
#> Reciprocal series of length Inf:
#> ..., 0.1666667, 0.2, 0.25, 0.3333333, 0.5, 1
print(-1 / natural1())
#> Negated series of length Inf:
#> -1, -0.5, -0.3333333, -0.25, -0.2, -0.1666667, ...
print(1 / integers())
#> Reciprocal series of length Inf:
#> -1, -0.5, -0.3333333, ..., 0.5, 1, Inf
print(1 / integers(), len = 1)
#> Reciprocal series of length Inf:
#> ..., Inf
print(1 / integers(), len = 0)
#> Reciprocal series of length Inf.
```
