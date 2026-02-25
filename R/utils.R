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
  as_integerish(res)
}

floor2 <- function(x, tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(x)
  checkmate::assert_number(tol, lower = 0, upper = 0.5)
  res <- floor(x)
  x_ceil <- ceiling(x)
  close_enough <- x_ceil - x < tol
  res[which(close_enough)] <- x_ceil[which(close_enough)]
  as_integerish(res)
}

#' "Safely" convert to integer-like
#' 
#' R doesn't allow numbers to hold an integer type if they are too big.
#' `as.integer()` will convert such numbers to `NA`, so that its output
#' is always of type "integer". `as_integerish()`, on the other hand,
#' would rather keep the original number and change the type to "double"
#' than to convert large numbers to `NA`.
#'
#' @param x Numeric vector. More specifically, an atomic vector that is
#'   coercable to numeric via `as.numeric()` without becoming `NA`.
#' @returns A vector comprising of whole numbers, with type "integer" if
#'   possible, but at least type "double". 
#' @details
#' When `as.integer()` coneverts a number to `NA`, `as_integerish()` will
#' instead drop the fractional part of the number, keeping the sign.
#' 
#' Values in `x` that are `NA` are preserved as `NA`.
#' 
#' `as.integer()` is quite forgiving with its inputs.
#' As of 'base' version 4.4.3, `as.integer("5.5")` returns `5L`, for example.
#' `as_integerish()` adopts the same behaviour by allowing inputs that don't
#' get converted to `NA` by `as.numeric()`.
#' @examples
#' suppressWarnings(as.integer(1e100))
#' discretes:::as_integerish(1e100)
#' discretes:::as_integerish(1e100 + 0.8) == 1e100
#' discretes:::as_integerish(-1e100 - 0.8) == -1e100
#' 
#' x <- discretes:::as_integerish(c(NA, 1, -5.5))
#' is.integer(x)
#' 
#' y <- discretes:::as_integerish(c(NA, 1, -5.5, 1e100))
#' is.integer(y)
as_integerish <- function(x) {
  checkmate::assert_atomic_vector(x)
  checkmate::assert_numeric(
    suppressWarnings(as.numeric(x[!is.na(x)])),
    any.missing = FALSE
  )
  as_int <- suppressWarnings(as.integer(x))
  newly_na <- !is.na(x) & is.na(as_int)
  if (any(newly_na)) {
    as_int[newly_na] <- sign(x[newly_na]) * floor(abs(x[newly_na]))
  }
  as_int
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
