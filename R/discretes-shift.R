#' Shift an infvctr
#'
#' @param x An infvctr object.
#' @param by A numeric value indicating the amount to shift (add) by.
#' @examples
#' shift(integers(), 5)
#'
#' @export
shift <- function(x, by) {
  checkmate::assert_number(by)
  structure(
    list(
      components = x,
      shift = by
    ),
    class = "shift_infvctr"
  )
}

#' @export
#' @inheritParams next_discrete
next_discrete.shift_infvctr <- function(x, from, ..., n = 1L, include_from = TRUE) {
  next_discrete(x$components, from = from, n = n, include_from = include_from) +
    x$shift
}

#' @export
#' @inheritParams next_discrete
prev_discrete.shift_infvctr <- function(x, from, ..., n = 1L, include_from = FALSE) {
  prev_discrete(x$components, from = from, n = n, include_from = include_from) +
    x$shift
}
