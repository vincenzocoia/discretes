#' Arithmetic Series
#'
#' Construct an arithmetic progression, with possibly infinite values.
#' The progression is anchored at `representative` and extends `n_left` steps
#' to the left (decreasing values) and `n_right` steps to the right
#' (increasing values) with constant `spacing` between consecutive terms.
#'
#' @param representative Numeric scalar giving a known term in the progression.
#' @param spacing Non-negative numeric scalar describing the distance between
#'   adjacent terms.
#' @param ... Reserved for future extensions; must be empty.
#' @param n_left,n_right Non-negative counts (possibly `Inf`) describing how
#'   many steps exist to the left and right of `representative`.
#' @return A `dsct_arithmetic` object, inheriting from `discretes`.
#' @examples
#' arithmetic(representative = -0.6, spacing = 0.7)
#' arithmetic(representative = 0.6, spacing = 0.7, n_right = 0)
#' arithmetic(representative = 0, spacing = 2, n_left = 2, n_right = 2)
#' @export
arithmetic <- function(representative,
                       spacing,
                       ...,
                       n_left = Inf,
                       n_right = Inf) {
  checkmate::assert_number(representative)
  checkmate::assert_number(spacing, lower = 0)
  ellipsis::check_dots_empty()
  n_left <- assert_and_convert_integerish(n_left, lower = 0)
  n_right <- assert_and_convert_integerish(n_right, lower = 0)
  new_discretes(
    data = list(
      representative = representative,
      spacing = spacing,
      n_left = n_left,
      n_right = n_right
    ),
    name = "Arithmetic",
    subclass = "dsct_arithmetic"
  )
}
