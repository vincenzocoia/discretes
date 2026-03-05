# "Safely" convert to integer-like

R doesn't allow numbers to hold an integer type if they are too big.
[`as.integer()`](https://rdrr.io/r/base/integer.html) will convert such
numbers to `NA`, so that its output is always of type "integer".
`as_integerish()`, on the other hand, would rather keep the original
number and change the type to "double" than to convert large numbers to
`NA`.

## Usage

``` r
as_integerish(x)
```

## Arguments

- x:

  Numeric vector. More specifically, an atomic vector that is coercable
  to numeric via [`as.numeric()`](https://rdrr.io/r/base/numeric.html)
  without becoming `NA`.

## Value

A vector comprising whole numbers, with type "integer" if possible, but
at least type "double".

## Details

When [`as.integer()`](https://rdrr.io/r/base/integer.html) converts a
number to `NA`, `as_integerish()` will instead drop the fractional part
of the number, keeping the sign.

Values in `x` that are `NA` are preserved as `NA`.

[`as.integer()`](https://rdrr.io/r/base/integer.html) is quite forgiving
with its inputs. As of 'base' version 4.4.3, `as.integer("5.5")` returns
`5L`, for example. `as_integerish()` adopts the same behaviour by
allowing inputs that don't get converted to `NA` by
[`as.numeric()`](https://rdrr.io/r/base/numeric.html).

## Examples

``` r
suppressWarnings(as.integer(1e100))
#> [1] NA
discretes:::as_integerish(1e100)
#> [1] 1e+100
discretes:::as_integerish(1e100 + 0.8) == 1e100
#> [1] TRUE
discretes:::as_integerish(-1e100 - 0.8) == -1e100
#> [1] TRUE

x <- discretes:::as_integerish(c(NA, 1, -5.5))
is.integer(x)
#> [1] TRUE

y <- discretes:::as_integerish(c(NA, 1, -5.5, 1e100))
is.integer(y)
#> [1] FALSE
```
