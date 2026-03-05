# Arithmetic series

Construct an arithmetic progression, with possibly infinite values. The
progression is anchored at `representative` and extends `n_left` steps
to the left (decreasing values) and `n_right` steps to the right
(increasing values) with constant `spacing` between consecutive terms.

## Usage

``` r
arithmetic(representative, spacing, ..., n_left = Inf, n_right = Inf)
```

## Arguments

- representative:

  Numeric scalar giving a known term in the progression.

- spacing:

  Non-negative numeric scalar describing the distance between adjacent
  terms.

- ...:

  Reserved for future extensions; must be empty.

- n_left, n_right:

  Non-negative counts (possibly `Inf`, the default) describing how many
  steps exist to the left and right of `representative`.

## Value

A numeric series (class `dsct_arithmetic`, inheriting from `discretes`).

## Note

While `spacing` can be zero, this results in a numeric series containing
only the `representative` value as its single discrete value.

The series can only contain `-0` if the `representative` is set as such.

## See also

[`integers()`](https://discretes.netlify.app/reference/integers.md)

## Examples

``` r
arithmetic(representative = -0.6, spacing = 0.7)
#> Arithmetic series of length Inf:
#> ..., -2, -1.3, -0.6, 0.1, 0.8, 1.5, ...
arithmetic(representative = 0.6, spacing = 0.7, n_right = 0)
#> Arithmetic series of length Inf:
#> ..., -2.9, -2.2, -1.5, -0.8, -0.1, 0.6
arithmetic(representative = 0, spacing = 2, n_left = 2, n_right = 2)
#> Arithmetic series of length 5:
#> -4, -2, 0, 2, 4

# Negative zero, resulting in `-Inf` upon inversion:
has_negative_zero(arithmetic(-0, 1))
#> [1] TRUE
```
