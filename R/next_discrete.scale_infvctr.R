#' @export
#' @inheritParams next_discrete
next_discrete.scale_infvctr <- function(x, from, ..., n = 1L, include_from = FALSE) {
  next_discrete(x$base, from = from, n = n, include_from = include_from) *
    x$scale
}
