#' @export
iv_shift.arithmetic_infvctr <- function(x, by) {
  checkmate::assert_number(by)
  x$representative <- x$representative + by
  x
}
