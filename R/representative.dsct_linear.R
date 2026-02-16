#' @noRd
#' @export
representative.dsct_linear <- function(x) {
  m <- x[["m"]]
  b <- x[["b"]]
  rp <- representative(x$base)
  if (is.null(b)) {
    return(m * rp)
  }
  m * rp + b
}
