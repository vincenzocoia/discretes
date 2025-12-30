#' @export
#' @inheritParams next_discrete
next_discrete.inverse <- function(x, from, ..., n = 1L, include_from = TRUE) {
  d_nested <- x$base
  if (from >= 0) {
    n_available <- distionary::num_discretes(
      d_nested, from = 0, to = 1 / from, include_from = FALSE,
      include_to = include_from
    )
    n <- min(n, n_available)
    x <- prev_discrete(
      d_nested, from = 1 / from, n = n, include_from = include_from
    )
  } else {
    x <- prev_discrete(
      d_nested, from = 1 / from, n = n, include_from = include_from
    )
    n_x <- length(x)
    n_remaining <- n - n_x
    if (n_remaining) {
      n_pos <- distionary::num_discretes(
        d_nested, from = 0, to = Inf, include_from = FALSE,
        include_to = FALSE
      )
      n_remaining <- min(n_remaining, n_pos)
      x_pos <- distionary::prev_discrete(
        d_nested, from = Inf, n = n_remaining, include_from = FALSE
      )
      x <- c(x, x_pos)
    }
  }
  1 / x
}

#' @export
#' @inheritParams next_discrete
prev_discrete.inverse <- function(x, from, ..., n = 1L, include_from = TRUE) {
  d_nested <- x$base
  if (from <= 0) {
    n_available <- distionary::num_discretes(
      d_nested, from = -1 / abs(from), to = 0,
      include_from = include_from, include_to = FALSE
    )
    n <- min(n, n_available)
    x <- distionary::next_discrete(
      d_nested, from = -1 / abs(from), n = n, include_from = include_from
    )
  } else {
    x <- distionary::next_discrete(
      d_nested, from = 1 / from, n = n, include_from = include_from
    )
    n_x <- length(x)
    n_remaining <- n - n_x
    if (n_remaining) {
      n_neg <- distionary::num_discretes(
        d_nested, from = -Inf, to = 0, include_from = FALSE,
        include_to = FALSE
      )
      n_remaining <- min(n_remaining, n_neg)
      x_neg <- distionary::next_discrete(
        d_nested, from = -Inf, n = n_remaining, include_from = FALSE
      )
      x <- c(x, x_neg)
    }
  }
  1 / x
}
