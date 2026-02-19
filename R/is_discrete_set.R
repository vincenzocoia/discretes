#' Check is if an object is understood as a discretes object
#'
#' This can happen if an object inherits the class "discretes", or if it
#' is a numeric vector.
#'
#' @param x Object to check.
#' @returns `TRUE` if `x` can be understood as a "discretes" object,
#' `FALSE` otherwise.
#' @examples
#' is_discrete_set(natural0())
#' is_discrete_set(c(1, 2, 3))
#' is_discrete_set("not a discretes")
#' @export
is_discrete_set <- function(x) {
  inherits(x, "discretes") || is.numeric(x)
}
