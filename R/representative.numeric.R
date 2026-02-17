#' @export
representative.numeric <- function(x) {
  x <- unique(x)
  x <- sort(x[!is.na(x)])
  l <- length(x)
  x[ceiling(l / 2)]
}
