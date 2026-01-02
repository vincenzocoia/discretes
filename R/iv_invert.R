#' @describeIn linear_transform Take element-wise reciprocals of an infvctr.
#' @export
iv_invert <- function(x) {
  UseMethod("iv_invert")
}

#' @export
print.inverse <- function(x, ...) {

}
