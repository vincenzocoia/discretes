#' Convert a discrete set to a numeric vector
#'
#' Return all discrete values in a "discretes" object, if finite.
#' If infinite, throws an error.
#'
#' @inheritParams num_discretes
#' @return A numeric vector containing all discrete values in `x`,
#'   ordered from smallest to largest. Returns `numeric(0)` when the interval
#'   contains no discrete values.
#' @examples
#' as.numeric(integers(-3.5, 10))
#' @exportS3Method base::as.double
as.double.discretes <- function(x, ...) {
  ellipsis::check_dots_empty()
  as.numeric(
    next_discrete(
      x,
      from = -Inf,
      n = Inf,
      include_from = TRUE
    )
  )
}
