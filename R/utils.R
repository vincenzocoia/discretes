#' Snap to integer with tolerance
#'
#' Get the floor or ceiling of a numeric vector, with a tolerance for
#' snapping values that are very close to an integer.
#'
#' @param x A numeric vector.
#' @param tol A non-negative number giving the tolerance; should not exceed 0.5.
#' @returns An integer vector where values within `tol` of an integer are
#' snapped to that integer, and all others have the usual `ceiling()` or
#' `floor()` applied except with an integer data type.
#' This means that, if `tol = 0`, the functions behave
#' exactly like `ceiling()` and `floor()`. If possible, the result will be
#' converted to an integer vector via `as.integer()`, although this is not
#' possible for values that are too big (see the documentation for 
#' `as.integer()` for current limits).
#' @examples
#' almost_six <- 6 - 1e-10
#' floor(almost_six)
#' floor2(almost_six)
#'
#' almost_seven <- 7 + 1e-10
#' ceiling(almost_seven)
#' ceiling2(almost_seven)
#' 
#' # Too big to be integer (as of base version 4.4.3)
#' ceiling2(c(NA, 1, 1e100)) 
#' floor2(c(NA, 1, 1e100))
#' @noRd
ceiling2 <- function(x, tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(x)
  checkmate::assert_number(tol, lower = 0, upper = 0.5)
  res <- ceiling(x)
  x_floor <- floor(x)
  close_enough <- x - x_floor < tol
  res[which(close_enough)] <- x_floor[which(close_enough)]
  possibly_as_integer(res)
}

floor2 <- function(x, tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(x)
  checkmate::assert_number(tol, lower = 0, upper = 0.5)
  res <- floor(x)
  x_ceil <- ceiling(x)
  close_enough <- x_ceil - x < tol
  res[which(close_enough)] <- x_ceil[which(close_enough)]
  possibly_as_integer(res)
}

# Convert a vector to integer via as.integer(), if possible.
# If the number is too big, as.integer() will return NA; this function
# is more forgiving and makes it numeric instead under this situation.
possibly_as_integer <- function(x) {
  try_int <- suppressWarnings(as.integer(x))
  originally_non_na <- try_int[!is.na(x)]
  if (any(is.na(originally_non_na))) {
    return(x)
  }
  try_int
}

#' Check if values are between two bounds
#' 
#' This function checks if each element of a numeric vector `x` lies within the
#' specified lower and upper bounds. You can choose whether each end is open
#' or closed.
#' @param x A numeric vector to be checked.
#' @param lower,upper Single numeric values specifying the lower and upper
#' bounds.
#' @param include_lower,include_upper Single logical values indicating whether
#' the lower and upper bounds are inclusive (closed, `TRUE`, the default) or
#' exclusive (open, `FALSE`).
#' @details The convention is adopted that, if `lower` and `upper` are equal,
#' both ends of the interval must be closed in order for any value to be
#' considered between them; otherwise, `FALSE` will be returned.
#' @returns A logical vector of the same length as `x`, with `TRUE` for elements
#' that lie within the specified bounds and `FALSE` otherwise. `NA` inputs
#' are propagated to the output.
#' @examples
#' discretes:::is_between(1:5, lower = 2, upper = 2)
#' discretes:::is_between(1:5, lower = 2, upper = 2, include_lower = FALSE)
#' discretes:::is_between(1:5, lower = 2, upper = 4, include_upper = FALSE)
is_between <- function(x,
                       lower,
                       upper,
                       include_lower = TRUE,
                       include_upper = TRUE) {
  checkmate::assert_numeric(x)
  checkmate::assert_number(lower)
  checkmate::assert_number(upper, lower = lower)
  checkmate::assert_logical(include_lower, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_upper, len = 1, any.missing = FALSE)
  if (include_lower) {
    inc_low <- x >= lower
  } else {
    inc_low <- x > lower
  }
  if (include_upper) {
    inc_up <- x <= upper
  } else {
    inc_up <- x < upper
  }
  inc_low & inc_up
}
