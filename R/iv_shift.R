#' Linear Transformation of Infvctrs
#'
#' @param x An infvctr object.
#' @param by A numeric value indicating the amount to shift (add) by.
#' @returns A linearly transformed infvctr object.
#' @examples
#' shift(integers(), 5)
#' @rdname linear_transform
#' @export
iv_shift <- function(x, by) {
  UseMethod("iv_shift")
}

