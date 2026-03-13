#' Check which values are in a numeric series
#'
#' @inheritParams next_discrete
#' @param values A vector of values to check.
#' @returns A logical vector indicating whether each value is in the numeric
#'   series `x`. `NA` values are preserved such that `NA` in `values` results
#'   in `NA` in the output.
#' @note This function does not distinguish between `+0` and `-0`. For that,
#'   use `has_negative_zero()` or `has_positive_zero()`.
#' @examples
#' has_discretes(natural0(), c(-1, 0, 1, 12.5, NA))
#' has_discretes(1 / natural1(), 0)
#' @export
has_discretes <- function(x,
                          values,
                          ...,
                          tol = sqrt(.Machine$double.eps)) {
  UseMethod("has_discretes")
}
