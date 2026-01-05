#' @export
num_discretes.numeric <- function(x,
                                  ...,
                                  from = -Inf,
                                  to = Inf,
                                  include_from = TRUE,
                                  include_to = TRUE,
                                  tol = sqrt(.Machine$double.eps)) {
  ellipsis::check_dots_empty()
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  x <- unique(x)
  x <- x[!is.na(x)]
  if (include_from) {
    left_query <- x >= from - tol
  } else {
    left_query <- x > from + tol
  }
  if (include_to) {
    right_query <- x <= to + tol
  } else {
    right_query <- x < to - tol
  }
  sum(left_query & right_query)
}
