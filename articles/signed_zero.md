# Signed Zero

``` r
library(discretes)
```

In R, zero has a latent sign: `+0` and `-0` print the same but behave
differently under reciprocation:

``` r
identical(0, -0)
#> [1] TRUE
1 / 0
#> [1] Inf
1 / -0
#> [1] -Inf
```

When a numeric series contains zero, that sign can matter for derived
series (for example, after inversion).

Support for signed zero is included in the discretes package so that the
proper signed infinity results by inversion:

``` r
x <- arithmetic(0, 3, n_left = 1, n_right = 1)
x
#> Arithmetic series of length 3:
#> -3, 0, 3
1 / x
#> Reciprocal series of length 3:
#> Loading required namespace: testthat
#> -0.3333333, 0.3333333, Inf
1 / -x
#> Reciprocal series of length 3:
#> -Inf, -0.3333333, 0.3333333
```

The functions
[`has_negative_zero()`](https://discretes.netlify.app/reference/negative_zero.md)
and
[`has_positive_zero()`](https://discretes.netlify.app/reference/negative_zero.md)
report whether `-0` or `+0` is a discrete value in the series. For
example, the integers contain a single positive zero:

``` r
has_negative_zero(integers())
#> [1] FALSE
has_positive_zero(integers())
#> [1] TRUE
```

Rules around signed zero follow those of base R. For example, negation
can induce negative zeroes (although note that, in R, -0 is only
possible as type “double” and not of type “integer”).

``` r
has_negative_zero(-1.5 * integers())
#> [1] FALSE
```

Like numeric vectors, a series can contain both signs of zero:

``` r
x <- dsct_union(-0, 0)
x
#> Union series of length 1:
#> 0
has_positive_zero(x)
#> [1] TRUE
has_negative_zero(x)
#> [1] TRUE
```

However, since they are both identical values, only one zero is
enumerated by
[`next_discrete()`](https://discretes.netlify.app/reference/next_discrete.md),
[`prev_discrete()`](https://discretes.netlify.app/reference/next_discrete.md),
or `get_discretes_*()`:

``` r
num_discretes(x)
#> [1] 1
```

But, both signs remain latent and appear when the series is inverted:

``` r
1 / x
#> Reciprocal series of length 2:
#> -Inf, Inf
num_discretes(1 / x)
#> [1] 2
```

When choosing to pull positive or negative zero from the series:

- For numeric vectors, behaviour is delegated to
  [`base::unique()`](https://rdrr.io/r/base/unique.html).
- For combined series through
  [`dsct_union()`](https://discretes.netlify.app/reference/dsct_union.md),
  the zero from the first series that has a zero is taken.
- Otherwise, positive zero is selected.
