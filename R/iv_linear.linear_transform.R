#' @describeIn linear_transform Compose linear transforms.
#' @export
iv_linear.linear_transform <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE)
  if (m < 0) {
    return(iv_linear(iv_negate(x), m = abs(m), b = b))
  }
  old_m <- x$m
  old_b <- x$b
  x$m <- old_m * m
  x$b <- old_b * m + b
  if (x$m == 1 && x$b == 0) {
    return(x$base)
  }
  x
}
