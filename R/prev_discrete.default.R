#' @export
#' @inheritParams next_discrete
prev_discrete.default <- function(x, from, ..., n = 1, include_from = TRUE) {
  -next_discrete(-x, from = -from, n = n, include_from = include_from)
}
