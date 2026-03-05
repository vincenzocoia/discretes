#' Check if an object is treated as a numeric series
#'
#' Returns `TRUE` if an object inherits the class `"discretes"` or is a
#' numeric vector.
#'
#' @param x Object to check.
#' @returns `TRUE` if `x` is treated as a numeric series, `FALSE` otherwise.
#' @examples
#' is_series(natural0())
#' is_series(c(1, 2, 3))
#' is_series("not a numeric series")
#' @export
is_series <- function(x) {
  inherits(x, "discretes") || is.numeric(x)
}
