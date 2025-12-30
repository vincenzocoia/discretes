#' @export
iv_multiply.default <- function(x, by) {
  checkmate::assert_number(by)
  if (by == 1) {
    return(x)
  }
  if (by == 0) {
    stop("Hmmm... still thinking about this one.")
  }
  if (by < 0) {
    x <- iv_negate(x)
    return(iv_multiply(iv_negate(x), by = abs(by)))
  }
  structure(list(base = x, scale = by), class = "scale_infvctr")
}
