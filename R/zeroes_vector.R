#' Construct vector of zeroes
#' 
#' Make a numeric (double) vector of zeroes of at most length 2:
#' contains `+0` if the series contains `+0`, and
#' contains `-0` if the series contains `-0`. Internal; useful for delegating
#' the behaviour of signed zero to how R does it for numeric vectors.
#' 
#' @inheritParams next_discrete
#' @returns A numeric (double) vector of zeroes, either of length 0, 1, or 2.
#' @examples
#' (none <- discretes:::zeroes_vector(natural1()))
#' 1 / none
#' 
#' (pos <- discretes:::zeroes_vector(integers()))
#' 1 / pos
#' 
#' (neg <- discretes:::zeroes_vector(arithmetic(-0, 1)))
#' 1 / neg
#' 
#' (posneg <- discretes:::zeroes_vector(dsct_union(integers(), -0)))
#' 1 / posneg
zeroes_vector <- function(x) {
  c(-0, 0)[c(has_negative_zero(x), has_positive_zero(x))]
}