#' @export
prev_discrete.dsct_inverse <- function(x,
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
  if (from <= 0) { # Grab discretes only on [1 / from, 0) going right.
    lower_bound <- -1 / abs(from)  # use "-" and abs() in case from = 0.
    n_available <- num_discretes(
      base,
      from = lower_bound,
      to = 0,
      include_from = include_from,
      include_to = FALSE,
      tol = tol
    )
    n <- min(n, n_available)
    collected <- next_discrete(
      base,
      from = lower_bound,
      n = n,
      include_from = include_from,
      tol = tol
    )
  } else { # Grab discretes going rght, first on [1 / from, Inf), then (-Inf, 0)
    collected <- next_discrete(
      base,
      from = 1 / from,
      n = n,
      include_from = include_from,
      tol = tol
    )
    n_remaining <- n - length(collected)
    n_available <- num_discretes(
      base,
      from = -Inf,
      to = 0,
      include_from = FALSE,
      include_to = FALSE,
      tol = tol
    )
    n_remaining <- min(n_available, n_remaining)
    extra <- next_discrete(
      base,
      from = -Inf,
      n = n_remaining,
      include_from = FALSE,
      tol = tol
    )
    collected <- append(collected, extra)
  }
  reciprocals <- 1 / collected
  sort(reciprocals, decreasing = TRUE)
}
