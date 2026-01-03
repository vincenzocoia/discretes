#' @noRd
#' @export
next_discrete.numeric <- function(x, from, ..., n = 1, include_from = TRUE) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, any.missing = FALSE, len = 1)
  x <- unique(x)
  x <- x[!is.na(x)]
  if (include_from) {
    upper_discretes <- x[x >= from]
  } else {
    upper_discretes <- x[x > from]
  }
  upper_discretes <- sort(upper_discretes)
  head(upper_discretes, n)
}
