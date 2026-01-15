#' @noRd
#' @export
dsct_negate.dsct_arithmetic <- function(x) {
  x$representative <- -x$representative
  n_left <- x$n_left
  x$n_left <- x$n_right
  x$n_right <- n_left
  attr(x, "sinks") <- -sinks(x)
  x
}
