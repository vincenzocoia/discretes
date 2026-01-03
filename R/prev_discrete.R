#' @rdname next_discrete
#' @export
prev_discrete <- function(x, from, ..., n = 1L, include_from = TRUE) {
  UseMethod("prev_discrete")
}

#' @noRd
#' @export
prev_discrete.discretes <- function(x, from, ..., n = 1, include_from = TRUE) {
  stop("Don't know how to walk backwards on this series.")
}
