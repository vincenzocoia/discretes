#' @export
#' @inheritParams next_discrete
next_discrete.inverse <- function(x, from, ..., n = 1L, include_from = TRUE) {
  checkmate::assert_number(from)
  checkmate::assert_integerish(n, lower = 0, len = 1)
  checkmate::assert_logical(include_from, len = 1)
  ellipsis::check_dots_empty()
  if (n == 0) {
    return(numeric(0))
  }
  base <- x$base
  collected <- numeric()
  if (from >= 0) {
    upper_bound <- 1 / from
    n_available <- num_discretes(
      base,
      from = 0,
      to = upper_bound,
      include_from = FALSE,
      include_to = include_from
    )
    n <- min(n, n_available)
    collected <- prev_discrete(
      base,
      from = upper_bound,
      n = n,
      include_from = include_from
    )
  } else {
    collected <- prev_discrete(
      base,
      from = 1 / from,
      n = n,
      include_from = include_from
    )
    n_remaining <- n - length(collected)
    extra <- prev_discrete(
      base,
      from = Inf,
      n = n_remaining,
      include_from = FALSE
    )
    extra <- extra[extra > 0]
    collected <- append(collected, extra)
  }
  reciprocals <- 1 / collected
  sort(reciprocals)
}
