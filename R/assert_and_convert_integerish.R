#' Assert and Convert Integerish, possibly Inf
#' @param x Input value; single length vector.
#' @param ... Additional arguments passed to `checkmate::assert_integerish()`.
#' @returns Single length integer vector, or `Inf`/`-Inf`. Like
#' `checkmate::assert_*()`, errors when not integerish or infinite, or if
#' not length 1. When not infinite, returns the integer.
#' @examples
#' assert_and_convert_integerish(Inf)  # Inf
#' assert_and_convert_integerish(-Inf)  # -Inf
#' assert_and_convert_integerish(5)    # 5L
#' assert_and_convert_integerish(5 - 1e-15)    # 5L
#' try(assert_and_convert_integerish(5.5))  # Error
#' try(assert_and_convert_integerish(1:10))  # Error
#' @noRd
assert_and_convert_integerish <- function(x, lower = -Inf, ...) {
  checkmate::assert_numeric(x, len = 1, lower = lower, any.missing = FALSE)
  if (is.infinite(x)) {
    return(x)
  }
  checkmate::assert_integerish(x, lower = lower, ...)
  as_integerish(round(x))
}
