#' @export
num_discretes.dsct_arithmetic <- function(x,
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
  if (from == to) {
    return(
      as.integer(
        include_from && include_to && test_discrete(x, values = from, tol = tol)
      )
    )
  }
  spacing <- x$spacing
  n_left <- x$n_left
  n_right <- x$n_right
  if (is.infinite(n_left) && is.infinite(from)) {
    return(Inf)
  }
  if (is.infinite(n_right) && is.infinite(to)) {
    return(Inf)
  }
  lower <- next_discrete(
    x, from = from, n = 1L, include_from = include_from, tol = tol
  )
  upper <- prev_discrete(
    x, from = to, n = 1L, include_from = include_to, tol = tol
  )
  if (!length(lower) || !length(upper) || upper < lower) {
    # Situations where we're looking outside of the series, or
    # when `from` and `to` are both in between two consecutive values.
    return(0L)
  }
  steps <- (upper - lower) / spacing
  as.integer(round(steps)) + 1L
}
