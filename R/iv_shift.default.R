#' @export
iv_shift.infvctr <- function(x, by) {
  checkmate::assert_number(by)
  if (by == 0) {
    return(x)
  }
  new_infvctr(list(base = x, shift = by), subclass = "shift_infvctr")
}
