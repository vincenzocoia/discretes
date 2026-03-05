# Check if a numeric series has a signed zero

Check if a numeric series contains zero with a negative sign (`-0`) or a
positive sign (`+0`). See details.

## Usage

``` r
has_negative_zero(x)

has_positive_zero(x)
```

## Arguments

- x:

  Numeric series (`numeric` vector or object of class `"discretes"`).

## Value

A single logical: whether `-0` is a discrete value in the series for
`has_negative_zero()`, and whether `+0` is a discrete value for
`has_positive_zero()`. Both can be `TRUE`; see details.

## Details

While `+0` and `-0` are identical in R, they have a latent sign that
appears in reciprocals: `1 / +0` is `Inf`, while `1 / -0` is `-Inf`. The
`has_negative_zero()` and `has_positive_zero()` functions report whether
`-0` and `+0` are discrete values in the numeric series. Behaviour is
consistent with signed zero in numeric vectors.

A numeric series can contain both `-0` and `+0`, like `c(0, -0)`. Only
one zero is returned by
[`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md),
[`prev_discrete()`](https://discretes.netlify.app/reference/next_discrete.md),
or
[`get_discretes_in()`](https://discretes.netlify.app/reference/get_discretes.md),
as with `unique(c(0, -0))`. Their presence remains latent and appears
when the series is inverted, giving both `Inf` and `-Inf`. See the
examples.

## Examples

``` r
has_negative_zero(integers())
#> [1] FALSE
has_positive_zero(integers())
#> [1] TRUE

# Integer 0 can never be negative, but double can:
has_negative_zero(-integers())
#> [1] FALSE
has_negative_zero(-1.5 * integers())
#> [1] FALSE

# -0 and +0 can co-exist, but are never double counted. However, they
# get expressed differently when the series is inverted.
a <- c(0, -0)
num_discretes(a)
#> [1] 1
num_discretes(1 / a)
#> [1] 2

b <- dsct_union(integers(from = -1, to = 1), -0)
num_discretes(b)
#> [1] 3
num_discretes(1 / b)
#> [1] 4
```
