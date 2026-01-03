#' @noRd
#' @export
prev_discrete.numeric <- function(x, from, ..., n = 1, include_from = TRUE) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, any.missing = FALSE, len = 1)
  x <- unique(x)
  x <- x[!is.na(x)]
  if (include_from) {
    lower_discretes <- x[x <= from]
  } else {
    lower_discretes <- x[x < from]
  }
  lower_discretes <- sort(lower_discretes, decreasing = TRUE)
  head(lower_discretes, n)
}
