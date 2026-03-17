# Convert to a discretes object

Convert a foreign object to a "discretes" object.

## Usage

``` r
as_discretes(x)

# S3 method for class 'discretes'
as_discretes(x)

# S3 method for class 'numeric'
as_discretes(x)
```

## Arguments

- x:

  Object to convert to object of class "discretes".

## Value

A numeric series (object of class `"discretes"`). When `x` is a numeric
vector, the series contains all unique values of `x`.

## Methods (by class)

- `as_discretes(discretes)`: Convert a numeric vector to discretes
  object.

- `as_discretes(numeric)`: Keeps the discretes object as-is.

## Examples

``` r
as_discretes(0:10)
#> Numeric vector series of length 11:
#> 0, 1, 2, ..., 8, 9, 10
```
