#' @export
has_infinite_discretes.numeric <- function(x, from, to) {
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  FALSE
}
