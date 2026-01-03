#' @noRd
#' @export
representative.dsct_linear <- function(x) {
  x$m * representative(x$base) + x$b
}
