#' @noRd
#' @export
num_discretes.dsct_arithmetic <- function(x,
                                          ...,
                                          from = -Inf,
                                          to = Inf,
                                          include_from = TRUE,
                                          include_to = TRUE) {
  ellipsis::check_dots_empty()
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  if (from == Inf) {
    return(0L)
  }
  spacing <- x$spacing
  n_left <- x$n_left
  n_right <- x$n_right
  if (spacing == 0) {
    spacing <- 1
    n_left <- 0
    n_right <- 0
  }
  if (is.infinite(n_left) && is.infinite(from)) {
    return(Inf)
  }
  if (is.infinite(n_right) && is.infinite(to)) {
    return(Inf)
  }
  lower <- next_discrete(x, from = from, n = 1L, include_from = include_from)
  upper <- prev_discrete(x, from = to, n = 1L, include_from = include_to)
  if (!length(lower) || !length(upper) || upper < lower) {
    return(numeric(0))
  }
  steps <- (upper - lower) / spacing
  checkmate::assert_true(checkmate::test_integerish(steps))
  as.integer(round(steps)) + 1L
}
