next_is_sink <- function(x, from, ..., tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discretes(x))
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  val <- next_discrete(x, from = from, n = 1L, include_from = FALSE, tol = tol)
  if (length(val)) {
    return(FALSE)
  }
  n <- num_discretes(x, from = from, include_from = FALSE, tol = tol)
  n > 0
}

prev_is_sink <- function(x, from, ..., tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discretes(x))
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  val <- prev_discrete(x, from = from, n = 1L, include_from = FALSE, tol = tol)
  if (length(val)) {
    return(FALSE)
  }
  n <- num_discretes(x, to = from, include_to = FALSE, tol = tol)
  n > 0
}

sink_is_between <- function(x, from, to, ..., tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discretes(x))
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  n <- num_discretes(x, from = from, to = to, tol = tol)
  n == Inf
}
