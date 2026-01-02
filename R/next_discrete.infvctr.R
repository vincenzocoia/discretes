#' @export
#' @inheritParams next_discrete
next_discrete.infvctr <- function(x, from, ..., n = 1L, include_from = FALSE) {
  stop("Don't know how to walk forwards on this series.")
}
