#' Test if values belong to a discrete set
#'
#' @param x An discretes object.
#' @param values A vector of values to check.
#' @param ... Reserved for future extensions; must be empty.
#' @param tol Numerical tolerance used for snapping `values`
#'   to discrete values in the series; single non-negative numeric.
#' @returns A logical vector indicating whether each value belongs to the
#'   discrete set defined by `x`. `NA` values are preserved such that `NA` in
#'   `values` results in `NA` in the output.
#' @examples
#' test_discrete(natural0(), c(-1, 0, 1, 12.5, NA))
#' test_discrete(1 / natural1(), 0)
#' @export
test_discrete <- function(x,
                          values,
                          ...,
                          tol = sqrt(.Machine$double.eps)) {
  UseMethod("test_discrete")
}
