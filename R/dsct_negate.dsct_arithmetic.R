#' @describeIn linear_transform Negate an arithmetic progression.
#' @export
dsct_negate.dsct_arithmetic <- function(x) {
  x$representative <- -x$representative
  n_left <- x$n_left
  x$n_left <- x$n_right
  x$n_right <- n_left
  x
}
