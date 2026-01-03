#' @rdname next_discrete
#' @export
prev_discrete <- function(x, from, ..., n = 1L, include_from = FALSE) {
  UseMethod("prev_discrete")
}

#' @export
#' @inheritParams next_discrete
prev_discrete.discretes <- function(x, from, ..., n = 1, include_from = TRUE) {
  stop("Don't know how to walk backwards on this series.")
}
