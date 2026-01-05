#' @export
num_discretes.dsct_inverse <- function(x,
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
  d_nested <- x$base
  if (sign(from) == sign(to)) {
    n <- num_discretes(
      d_nested,
      from = 1 / to, to = 1 / from,
      include_from = include_to, include_to = include_from,
      tol = tol
    )
    return(n)
  }
  if (from == 0) {
    n <- num_discretes(
      d_nested,
      from = 1 / to, to = Inf,
      include_from = include_to,
      tol = tol
    )
    return(n)
  }
  if (to == 0) {
    n <- num_discretes(
      d_nested,
      from = -Inf, to = 1 / from,
      include_to = include_from,
      tol = tol
    )
    return(n)
  }
  n_neg <- num_discretes(
    d_nested,
    from = -Inf, to = 1 / from,
    include_to = include_from,
    tol = tol
  )
  n_pos <- num_discretes(
    d_nested,
    from = 1 / to, to = Inf,
    include_from = include_to,
    tol = tol
  )
  n_neg + n_pos
}
