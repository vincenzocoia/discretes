#' @rdname num_discretes
#' @export
has_infinite_discretes <- function(x, ..., from = -Inf, to = Inf) {
  checkmate::assert_true(inherits(x, "infvctr") || is.numeric(x))
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  n <- num_discretes(x, from = from, to = to)
  is.infinite(n)
}
