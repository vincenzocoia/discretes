#' Snap to integer with tolerance
#'
#' Get the floor or ceiling of a numeric vector, with a tolerance for
#' snapping values that are very close to an integer.
#'
#' @param x A numeric vector.
#' @param tol A non-negative number giving the tolerance; should not exceed 0.5.
#' @returns Am integer vector where values within `tol` of an integer are
#' snapped to that integer, and all others have the usual `ceiling()` or
#' `floor()` applied except with an integer data type.
#' This means that, if `tol = 0`, the functions behave
#' exactly like `ceiling()` and `floor()`.
#' @examples
#' almost_six <- 6 - 1e-10
#' floor(almost_six)
#' floor2(almost_six)
#'
#' almost_seven <- 7 + 1e-10
#' ceiling(almost_seven)
#' ceiling2(almost_seven)
#' @noRd
ceiling2 <- function(x, tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(x)
  checkmate::assert_number(tol, lower = 0, upper = 0.5)
  res <- ceiling(x)
  x_floor <- floor(x)
  close_enough <- x - x_floor < tol
  res[close_enough] <- x_floor[close_enough]
  as.integer(res)
}

floor2 <- function(x, tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(x)
  checkmate::assert_number(tol, lower = 0, upper = 0.5)
  res <- floor(x)
  x_ceil <- ceiling(x)
  close_enough <- x_ceil - x < tol
  res[close_enough] <- x_ceil[close_enough]
  as.integer(res)
}
