#' @export
#' @inheritParams next_discrete
next_discrete.default <- function(x, from, ..., n = 1, include_from = TRUE) {
  stop("don't know")
}

#' @export
has_infinite_discretes.default <- function(x, from, to) {
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  n <- num_discretes(x, from = from, to = to)
  is.infinite(n)
}

#' @export
num_discretes.default <- function(x,
                                  from,
                                  to,
                                  ...,
                                  include_from = TRUE,
                                  include_to = TRUE) {
  stop("don't know")
}

#' @export
#' @inheritParams next_discrete
prev_discrete.default <- function(x, from, ..., n = 1, include_from = TRUE) {
  -next_discrete(-x, from = -from, n = n, include_from = include_from)
}
