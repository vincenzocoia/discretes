#' @describeIn numeric_discretes Count discrete numeric values within a range.
#' @export
num_discretes.numeric <- function(x,
                                  ...,
                                  from = -Inf,
                                  to = Inf,
                                  include_from = TRUE,
                                  include_to = TRUE) {
  ellipsis::check_dots_empty()
  checkmate::assert_number(from)
  checkmate::assert_number(to)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  x <- unique(x)
  x <- x[!is.na(x)]
  if (include_from) {
    left_query <- x >= from
  } else {
    left_query <- x > from
  }
  if (include_to) {
    right_query <- x <= to
  } else {
    right_query <- x < to
  }
  sum(left_query & right_query)
}
