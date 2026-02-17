#' @export
representative.dsct_arithmetic <- function(x) {
  res <- x$representative
  mode(res) <- typeof(res + x$spacing)
  res
}
