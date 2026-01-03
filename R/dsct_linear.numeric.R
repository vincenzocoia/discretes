#' @export
dsct_linear.numeric <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE)
  m * x + b
}
