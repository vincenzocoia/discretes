#' Check is if an object is understood as a discretes object
#'
#' This can happen if an object inherits the class "discretes", or if it
#' is a numeric vector.
#'
#' @param x Object to check.
#' @returns `TRUE` if `x` can be understood as a "discretes" object,
#' `FALSE` otherwise.
#' @examples
#' is_discretes(natural0())
#' is_discretes(c(1, 2, 3))
#' is_discretes("not a discretes")
#' @export
is_discretes <- function(x) {
  inherits(x, "discretes") || is.numeric(x)
}
