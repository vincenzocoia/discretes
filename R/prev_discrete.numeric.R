#' @export
prev_discrete.numeric <- function(x,
                                  from,
                                  ...,
                                  n = 1,
                                  include_from = TRUE,
                                  tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  x <- unique(x)
  x <- x[!is.na(x)]
  if (include_from) {
    lower_discretes <- x[x <= from + tol]
  } else {
    lower_discretes <- x[x < from - tol]
  }
  lower_discretes <- sort(lower_discretes, decreasing = TRUE)
  utils::head(lower_discretes, n)
}
