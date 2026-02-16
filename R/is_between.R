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