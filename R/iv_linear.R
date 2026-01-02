#' Linear Transformation of Infvctrs
#'
#' @param x An infvctr object.
#' @param m A numeric value indicating the multiplier.
#' @param b A numeric value indicating the bias (addend).
#' @returns A linearly transformed infvctr object.
#' @examples
#' iv_linear(integers(), m = 2, b = 3)
#' @rdname linear_transform
#' @export
iv_linear <- function(x, m, b) {
  UseMethod("iv_linear")
}
