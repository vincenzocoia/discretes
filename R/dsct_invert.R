#' Reciprocal Series
#'
#' Take the reciprocal of values in a series of discretes.
#' @param x Discretes object.
#' @returns A new series of discretes containing the reciprocals of all values
#'   in `x`.
#' @noRd
dsct_invert <- function(x) {
  UseMethod("dsct_invert")
}

#' @noRd
#' @exportS3Method
dsct_invert.discretes <- function(x) {
  new_discretes(
    data = list(base = x),
    name = "Reciprocal",
    subclass = "dsct_inverse"
  )
}
