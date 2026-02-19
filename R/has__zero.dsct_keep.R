#' @export
has_negative_zero.dsct_keep <- function(x) {
  has_discretes(x, values = 0) && has_negative_zero(x$base)
}

#' @export
has_positive_zero.dsct_keep <- function(x) {
  has_discretes(x, values = 0) && has_positive_zero(x$base)
}

