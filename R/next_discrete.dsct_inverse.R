#' @noRd
#' @export
next_discrete.dsct_inverse <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = TRUE,
                                       tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (n == 0) {
    return(numeric(0))
  }
  base <- x$base
  if (from >= 0) { # Grab discretes only on (0, 1 / from] going left.
    upper_bound <- 1 / from
    n_available <- num_discretes(
      base,
      from = 0,
      to = upper_bound,
      include_from = FALSE,
      include_to = include_from,
      tol = tol
    )
    n <- min(n, n_available)
    collected <- prev_discrete(
      base,
      from = upper_bound,
      n = n,
      include_from = include_from,
      tol = tol
    )
  } else { # Grab discretes going left, first on (-Inf, 1 / from], then (0, Inf)
    collected <- prev_discrete(
      base,
      from = 1 / from,
      n = n,
      include_from = include_from,
      tol = tol
    )
    n_remaining <- n - length(collected)
    n_available <- num_discretes(
      base,
      from = 0,
      to = Inf,
      include_from = FALSE,
      include_to = FALSE,
      tol = tol
    )
    n_remaining <- min(n_available, n_remaining)
    extra <- prev_discrete(
      base,
      from = Inf,
      n = n_remaining,
      include_from = FALSE,
      tol = tol
    )
    collected <- append(collected, extra)
  }
  reciprocals <- 1 / collected
  sort(reciprocals)
}
