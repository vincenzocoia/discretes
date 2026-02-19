#' @export
has_negative_zero.dsct_arithmetic <- function(x) {
  rp <- x$representative
  has_negative_zero(rp)
}

#' @export
has_positive_zero.dsct_arithmetic <- function(x) {
  rp <- x$representative
  has_discretes(x, values = 0) && !has_negative_zero(x)
}
