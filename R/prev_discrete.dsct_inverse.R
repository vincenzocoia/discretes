#' @noRd
#' @export
prev_discrete.dsct_inverse <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = TRUE) {
  checkmate::assert_number(from)
  checkmate::assert_integerish(n, lower = 0, len = 1)
  checkmate::assert_logical(include_from, len = 1)
  if (n == 0) {
    return(numeric(0))
  }
  base <- x$base
  if (from <= 0) { # Grab discretes only on [1 / from, 0) going right.
    lower_bound <- 1 / from
    n_available <- num_discretes(
      base,
      from = lower_bound,
      to = 0,
      include_from = include_from,
      include_to = FALSE
    )
    n <- min(n, n_available)
    collected <- next_discrete(
      base,
      from = lower_bound,
      n = n,
      include_from = include_from,
      ...
    )
  } else { # Grab discretes going rght, first on [1 / from, Inf), then (-Inf, 0)
    collected <- next_discrete(
      base,
      from = 1 / from,
      n = n,
      include_from = include_from,
      ...
    )
    n_remaining <- n - length(collected)
    n_available <- num_discretes(
      base,
      from = -Inf,
      to = 0,
      include_from = FALSE,
      include_to = FALSE
    )
    n_remaining <- min(n_available, n_remaining)
    extra <- next_discrete(
      base,
      from = -Inf,
      n = n_remaining,
      include_from = FALSE,
      ...
    )
    collected <- append(collected, extra)
  }
  reciprocals <- 1 / collected
  sort(reciprocals, decreasing = TRUE)
}
