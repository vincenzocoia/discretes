#' @rdname next_discrete
#' @export
prev_discrete <- function(x, from, ..., n = 1L, include_from = FALSE) {
  UseMethod("prev_discrete")
}
