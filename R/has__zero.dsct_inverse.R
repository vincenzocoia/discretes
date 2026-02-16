#' @export
has_negative_zero.dsct_inverse <- function(x) {
  base <- x$base
  test_discrete(base, values = -Inf)
}

#' @export
has_positive_zero.dsct_inverse <- function(x) {
  base <- x$base
  test_discrete(base, values = Inf)
}

