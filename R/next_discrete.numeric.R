#' @noRd
#' @export
next_discrete.numeric <- function(x,
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
  has_na <- any(is.na(x))
  x <- x[!is.na(x)]
  if (include_from) {
    upper_discretes <- x[x >= from - tol]
  } else {
    upper_discretes <- x[x > from + tol]
  }
  upper_discretes <- sort(upper_discretes)
  utils::head(upper_discretes, n)
}
