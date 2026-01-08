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
  has_na <- any(is.na(x))
  x <- unique(x)
  if (from == to) {
    if (include_from && include_to) {
      return(as.integer(test_discrete(x, values = from, tol = tol)))
    }
    return(0L)
  }
  x <- x[!is.na(x)]
  if (has_na) {
    if (is.integer(x) && is.finite(from) && is.finite(to)) {
      from_int <- ceiling2(from, tol = tol)
      to_int <- floor2(to, tol = tol)
      if (from_int > to_int) {
        return(0L)
      }
      if (abs(from_int - from) > tol) {
        include_from <- TRUE
      }
      if (abs(to_int - to) > tol) {
        include_to <- TRUE
      }
      n_series <- to_int - from_int - 1L + include_from + include_to
      series <- from_int + seq_len(n_series) - include_from
      if (all(series %in% x)) {
        return(as.integer(n_series))
      }
    }
    return(NA_integer_)
  }
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
