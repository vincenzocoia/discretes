#' Convert a discrete set to a numeric vector
#'
#' Return all discrete values in a "discretes" object, if finite.
#' Throws an error if infinite.
#'
#' @inheritParams num_discretes
#' @param ... Arguments to pass downstream to `as.numeric()` that's called
#'   on the resulting vector of discrete values.
#' @return A numeric vector containing all discrete values in `x`,
#'   ordered from smallest to largest. Returns `numeric(0)` when the interval
#'   contains no discrete values. Numeric outputs are wrapped in `as.numeric()`.
#' @examples
#' as.numeric(integers(-3.5, 10))
#' @seealso [get_discretes_in()]
#' @exportS3Method base::as.double
as.double.discretes <- function(x, ...) {
  as.numeric(get_discretes_in(x), ...)
}
