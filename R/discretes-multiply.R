#' @export
#' @inheritParams next_discrete
next_discrete.scale <- function(x, from, ..., n = 1L, include_from = FALSE) {
  next_discrete(x$components, from = from, n = n, include_from = include_from) *
    x$scale
}

#' @export
#' @inheritParams next_discrete
prev_discrete.scale <- function(x, from, ..., n = 1L, include_from = FALSE) {
  prev_discrete(x$components, from = from, n = n, include_from = include_from) *
    x$scale
}
