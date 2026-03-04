#' Check if a numeric series has a signed zero
#'
#' Check if a numeric series contains zero with a negative sign (`-0`)
#' or a positive sign (`+0`). See details.
#'
#' @inheritParams next_discrete
#' @returns A single logical: whether `-0` is a discrete value in the series
#'   for `has_negative_zero()`, and whether `+0` is a discrete value for
#'   `has_positive_zero()`. Both can be `TRUE`; see details.
#' @details
#' While `+0` and `-0` are identical in R, they have a latent sign that
#' appears in reciprocals: `1 / +0` is `Inf`, while `1 / -0` is `-Inf`. The
#' `has_negative_zero()` and `has_positive_zero()` functions report whether
#' `-0` and `+0` are discrete values in the numeric series. Behaviour is
#' consistent with signed zero in numeric vectors.
#'
#' A numeric series can contain both `-0` and `+0`, like `c(0, -0)`. Only one
#' zero is returned by `next_discrete()`, `prev_discrete()`, or
#' `get_discretes_in()`, as with `unique(c(0, -0))`. Their presence remains
#' latent and appears when the series is inverted, giving both `Inf` and
#' `-Inf`. See the examples.
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
