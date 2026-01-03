#' @describeIn linear_transform Compose linear transforms.
#' @export
dsct_linear.dsct_linear <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE)
  if (m < 0) {
    return(dsct_linear(dsct_negate(x), m = abs(m), b = b))
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
