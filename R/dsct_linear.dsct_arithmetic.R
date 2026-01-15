#' @noRd
#' @export
dsct_linear.dsct_arithmetic <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE)
  x$representative <- x$representative * m + b
  x$spacing <- x$spacing * abs(m)
  if (m < 0) {
    old_n_left <- x$n_left
    x$n_left <- x$n_right
    x$n_right <- old_n_left
    attr(x, "sinks") <- -sinks(x)
  }
  x
}
