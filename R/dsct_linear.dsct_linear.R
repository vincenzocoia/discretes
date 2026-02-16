#' @noRd
#' @export
dsct_linear.dsct_linear <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  if (!missing(b)) {
    checkmate::assert_number(b, finite = TRUE)
  }
  old_m <- x[["m"]]
  old_b <- x[["b"]]
  if (missing(b) && is.null(old_b)) {
    # m2 * (m1 * x)
    return(dsct_linear(x$base, m = m * old_m))
  }
  if (missing(b)) {
    # m2 * (m1 * x + b1)
    return(dsct_linear(x$base, m = m * old_m, b = m * old_b))
  }
  # m2 * (m1 * x + b1) + b2
  dsct_linear(x$base, m = m * old_m, b = m * old_b + b)
}
