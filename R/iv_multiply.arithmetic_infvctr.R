#' @export
iv_multiply.arithmetic_infvctr <- function(x, by) {
  checkmate::assert_number(by)
  if (by == 0) {
    stop("Hmmm... still thinking about this one.")
  }
  if (by < 0) {
    x <- iv_negate(x)
    return(iv_multiply(iv_negate(x), by = abs(by)))
  }
  x$spacing <- x$spacing * by
  x$representative <- x$representative * by
  x
}
