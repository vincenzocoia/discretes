#' @export
iv_linear.infvctr <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE)
  if (m < 0) {
    return(iv_linear(iv_negate(x), m = abs(m), b = b))
  }
  if (m == 1 && b == 0) {
    return(x)
  }
  new_infvctr(
    data = list(base = x, m = m, b = b),
    subclass = "linear_transform"
  )
}
