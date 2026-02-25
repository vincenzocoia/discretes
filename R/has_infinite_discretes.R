#' @rdname num_discretes
#' @export
has_infinite_discretes <- function(x,
                                   from = -Inf,
                                   to = Inf,
                                   ...,
                                   tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(inherits(x, "discretes") || is.numeric(x))
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_number(tol, lower = 0)
  n <- num_discretes(x, from = from, to = to, tol = tol, ...)
  is.infinite(n)
}
