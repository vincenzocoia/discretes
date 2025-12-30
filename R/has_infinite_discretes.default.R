#' @export
has_infinite_discretes.default <- function(x, from, to) {
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  n <- num_discretes(x, from = from, to = to)
  is.infinite(n)
}
