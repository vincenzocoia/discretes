#' @export
#' @inheritParams next_discrete
prev_discrete.infvctr <- function(x, from, ..., n = 1, include_from = TRUE) {
  stop("Don't know how to walk backwards on this series.")
}
