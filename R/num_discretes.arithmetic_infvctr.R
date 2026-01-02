#' @export
num_discretes.arithmetic_infvctr <- function(x,
                                             ...,
                                             from = -Inf,
                                             to = Inf,
                                             include_from = TRUE,
                                             include_to = TRUE) {
  ellipsis::check_dots_empty()
  from <- assert_and_convert_integerish(from)
  to <- assert_and_convert_integerish(to, lower = from)
  checkmate::assert_logical(include_from, len = 1)
  checkmate::assert_logical(include_to, len = 1)
  if (from == Inf) {
    return(0L)
  }
  if (is.infinite(x$n_left) && is.infinite(from)) {
    return(Inf)
  }
  if (is.infinite(x$n_right) && is.infinite(to)) {
    return(Inf)
  }
  lower <- next_discrete(
    x, from = from, n = 1L, include_from = include_from, tol = tol
  )
  upper <- prev_discrete(
    x, from = to, n = 1L, include_from = include_to, tol = tol
  )
  if (upper < lower) {
    return(0L)
  }

  steps <- (upper - lower) / x$spacing
  checkmate::assert_true(checkmate::test_integerish(steps, tol = tol))
  as.integer(round(steps)) + 1L
}
