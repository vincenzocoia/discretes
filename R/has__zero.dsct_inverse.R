#' @export
has_negative_zero.dsct_inverse <- function(x) {
  base <- x$base
  has_discretes(base, values = -Inf)
}

#' @export
has_positive_zero.dsct_inverse <- function(x) {
  base <- x$base
  has_discretes(base, values = Inf)
}

