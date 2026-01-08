#' Linear Transformation of discretes
#'
#' @param x An discretes object.
#' @param m A numeric value indicating the multiplier.
#' @param b A numeric value indicating the bias (addend).
#' @returns A linearly transformed discretes object.
#' @examples
#' dsct_linear(integers(), m = 2, b = 3)
#' @noRd
#' @export
dsct_linear <- function(x, m, b) {
  UseMethod("dsct_linear")
}

#' @noRd
#' @export
dsct_linear.discretes <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE)
  if (m < 0) {
    return(dsct_linear(dsct_negate(x), m = abs(m), b = b))
  }
  if (m == 1 && b == 0) {
    return(x)
  }
  new_discretes(
    data = list(base = x, m = m, b = b),
    name = "Linear-transformed",
    subclass = "dsct_linear"
  )
}
