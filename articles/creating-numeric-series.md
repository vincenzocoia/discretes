# Creating numeric series

``` r
library(discretes)
```

The discretes package lets you create basic numeric series in two main
ways:

**Arithmetic series** — Use
[`arithmetic()`](https://discretes.netlify.app/reference/arithmetic.md)
or the wrappers
[`integers()`](https://discretes.netlify.app/reference/integers.md),
[`natural1()`](https://discretes.netlify.app/reference/integers.md), and
[`natural0()`](https://discretes.netlify.app/reference/integers.md) for
common cases (all integers, positive integers starting at 1,
non-negative integers starting at 0).

**From a numeric vector** — Use
[`as_discretes()`](https://discretes.netlify.app/reference/as_discretes.md)
to turn an existing numeric vector into a numeric series.

Once you have a base series, you can create new ones by subsetting,
combining, or transforming.

## Subsetting and combining

- **Subsetting**:
  [`dsct_keep()`](https://discretes.netlify.app/reference/subsetting.md)
  and
  [`dsct_drop()`](https://discretes.netlify.app/reference/subsetting.md)
  restrict a series to or outside of an interval.
- **Combining**:
  [`dsct_union()`](https://discretes.netlify.app/reference/dsct_union.md)
  merges multiple series into one.

## Arithmetic and standard functions

**Arithmetic** — The operations `+`, `-`, `*`, `/`, `^` are supported
when one side is a number and the other is a numeric series. For
example:

``` r
integers()^2
#> Loading required namespace: testthat
#> Union series of length Inf:
#> 0, 1, 4, 9, 16, 25, ...
2 * natural1() - 1   # odd positive integers
#> Linear-transformed series of length Inf:
#> 1, 3, 5, 7, 9, 11, ...
1 / 2^integers()     # reciprocals of powers of 2
#> Reciprocal series of length Inf:
#> ..., 0.25, 0.5, 1, 2, 4, 8, ...
```

Length-0 vectors are allowed, too, but result in empty series:

``` r
numeric(0L) * natural1()
#> Empty series.
```

**Mathematical functions** — [`exp()`](https://rdrr.io/r/base/Log.html)
is supported. For non-negative series,
[`log()`](https://rdrr.io/r/base/Log.html),
[`log2()`](https://rdrr.io/r/base/Log.html),
[`log10()`](https://rdrr.io/r/base/Log.html), and
[`sqrt()`](https://rdrr.io/r/base/MathFun.html) are also supported:

``` r
log(natural0())
#> Transformed series of length Inf:
#> -Inf, 0, 0.6931472, 1.098612, 1.386294, 1.609438, ...
```

Other functions may be able to be applied as well; use
[`dsct_transform()`](https://discretes.netlify.app/reference/transform.md)
for those (see below).

## Custom transformations: `dsct_transform()`

For other transformations, use
[`dsct_transform()`](https://discretes.netlify.app/reference/transform.md).
On a numeric vector, the function is applied directly:

``` r
dsct_transform(0:10, cos) # Same as cos(0:10)
#>  [1]  1.0000000  0.5403023 -0.4161468 -0.9899925 -0.6536436  0.2836622
#>  [7]  0.9601703  0.7539023 -0.1455000 -0.9111303 -0.8390715
```

When transforming an object of class `"discretes"` there are more
restrictions so that querying the series can be defined from the base
series.

1.  The function and its inverse must be vectorized and element-wise (no
    [`cumsum()`](https://rdrr.io/r/base/cumsum.html)-style dependence on
    other elements).
2.  You must supply the **domain** and **range** of the function. This
    defaults to all real numbers.
3.  The function must be [strictly
    monotonic](https://en.wikipedia.org/wiki/Monotonic_function) over
    the given domain.

Here is an example of applying the function
[`pnorm()`](https://rdrr.io/r/stats/Normal.html). The range is (0, 1),
so it must be given explicitly:

``` r
dsct_transform(
  natural0(),
  fun = pnorm,
  inv = qnorm,
  range = c(0, 1)
)
#> Transformed series of length Inf:
#> 0.5, 0.8413447, 0.9772499, 0.9986501, 0.9999683, 0.9999997, ...
```

For a function that is monotonic only on an interval, restrict the
domain. For example, [`cos()`](https://rdrr.io/r/base/Trig.html) is
decreasing on `[0, pi]` with range `[-1, 1]`, and inverse
[`acos()`](https://rdrr.io/r/base/Trig.html). Specify
`dir = "decreasing"` to indicate that this is a decreasing function.

``` r
dsct_transform(
  integers(from = 0, to = 3),
  fun = cos,
  inv = acos,
  domain = c(0, pi),
  range = c(-1, 1),
  dir = "decreasing"
)
#> Transformed series of length 4:
#> -0.9899925, -0.4161468, 0.5403023, 1
```
