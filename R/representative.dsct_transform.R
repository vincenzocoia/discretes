#' @noRd
#' @export
representative.dsct_transform <- function(x) {
  x[["fun"]](representative(x[["base"]]))
}
