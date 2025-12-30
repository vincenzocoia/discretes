#' @export
iv_negate.arithmetic_infvctr <- function(x) {
  x$representative <- -x$representative
  n_left <- x$n_left
  x$n_left <- x$n_right
  x$n_right <- n_left
  x
}
