#' Check if an object is treated as a numeric series
#'
#' Returns `TRUE` if an object inherits the class `"discretes"` or is a
#' numeric vector.
#'
#' @param x Object to check.
#' @returns `TRUE` if `x` is treated as a numeric series, `FALSE` otherwise.
#' @examples
#' is_discrete_set(natural0())
#' is_discrete_set(c(1, 2, 3))
#' is_discrete_set("not a numeric series")
#' @export
is_discrete_set <- function(x) {
  inherits(x, "discretes") || is.numeric(x)
}
