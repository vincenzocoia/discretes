#' @noRd
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
  if (from == -Inf || n == 0) {
    return(vector(mode = typeof(x), length = 0))
  }
  has_na <- any(is.na(x))
  x <- unique(x)
  x <- x[!is.na(x)]
  if (include_from) {
    lower_discretes <- x[x <= from + tol]
  } else {
    lower_discretes <- x[x < from - tol]
  }
  lower_discretes <- sort(lower_discretes, decreasing = TRUE)
  lower_discretes <- utils::head(lower_discretes, n)
  if (has_na) {
    if (is.integer(x) && is.finite(n)) {
      from_int <- floor2(from, tol = tol)
      if (abs(from_int - from) > tol) {
        include_from <- TRUE
      }
      ref <- from_int - (seq_len(n) - include_from)
      if (identical(ref, lower_discretes)) {
        return(lower_discretes)
      }
    }
    if (test_discrete(x, values = from, tol = tol) && include_from && n == 1) {
      return(lower_discretes)
    }
    stop("Cannot determine the length of the output due to NA values in 'x'.")
  }
  lower_discretes
}
