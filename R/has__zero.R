#' Check if a discrete value series has a signed zero
#' 
#' Check if a discrete value series contains zero with a negative sign (`-0`)
#' or a positive sign (`+0`). See details.
#' 
#' @inheritParams dsct_negate
#' @returns A single logical vector indicating whether `-0` is present
#'   in the series for `has_negative_zero()`, and whether `+0` is present in the
#'   series for `has_positive_zero()`. Both could be `TRUE`; see details.
#' @details 
#' While `+0` and `-0` are identical numbers in R, they have a latent sign
#' property that gets expressed through their reciprocals: `1 / +0` is `Inf`,
#' while `1 / -0` is `-Inf`. The `has_negative_zero()` and `has_positive_zero()`
#' functions are how the presence of `-0` and `+0` is tracked in a discrete
#' value series. The behaviour of signed zero in a discrete value series is
#' made consistent with the behaviour of signed zero in numeric vectors.
#' 
#' It's possible for a discrete value series to contain both `-0` and
#' `+0`, just like the numeric vector `c(0, -0)` contains both. However, only
#' one zero will ever get expressed when calling `next_discrete()`,
#' `prev_discrete()`, or `as.numeric()`, similar to the behaviour of
#' `unique(c(0, -0))`. However, their presence remains latent in the encoding
#' of the series, and will get expressed differently when the series is
#' inverted, spawning both `Inf` and `-Inf`. See the examples.
#' @examples
#' has_negative_zero(integers())
#' has_positive_zero(integers())
#' 
#' # Integer 0 can never be negative, but double can:
#' has_negative_zero(-integers())
#' has_negative_zero(-1.5 * integers())
#' 
#' # -0 and +0 can co-exist, but are never double counted. However, they
#' # get expressed differently when the series is inverted.
#' a <- c(0, -0)
#' num_discretes(a)
#' num_discretes(1 / a)
#' 
#' b <- dsct_union(integers(from = -1, to = 1), -0)
#' num_discretes(b)
#' num_discretes(1 / b)
#' @rdname negative_zero
#' @export
has_negative_zero <- function(x) UseMethod("has_negative_zero")

#' @rdname negative_zero
#' @export
has_positive_zero <- function(x) UseMethod("has_positive_zero")

#' @export
has_negative_zero.discretes <- function(x) {
  stop("Cannot determine presence of -0 in this series.")
}

#' @export
has_positive_zero.discretes <- function(x) {
  stop("Cannot determine presence of +0 in this series.")
}
