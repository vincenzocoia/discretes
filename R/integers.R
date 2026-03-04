#' Integer numeric series
#'
#' Use `integers()` to create a numeric series whose discrete values are
#' integers within a specified range, possibly unbounded on either end. Use
#' `natural0()` and `natural1()` for the natural numbers starting at 0 or 1.
#'
#' @param from,to Numeric values defining the range of integers.
#'   Defaults to `-Inf` and `Inf`, representing all integers; the series
#'   is not closed, so `-Inf` and `Inf` are never discrete values.
#' @returns A numeric series (arithmetic, class `"dsct_arithmetic"`)
#'   whose discrete values are the integers in the specified range.
#' @examples
#' integers()                  # All integers
#' integers(from = 0)          # Non-negative integers
#' integers(to = 1.5)          # Ends at 1.
#' integers(-5, 5) # Integers from -5 to 5.
#' natural1()
#' natural0()
#' 
#' # Infinity is never contained in the series.
#' has_discretes(integers(), Inf)
#' @rdname integers
#' @seealso [arithmetic()]
#' @export
integers <- function(from = -Inf, to = Inf) {
  checkmate::assert_number(from, finite = FALSE)
  checkmate::assert_number(to, lower = from, finite = FALSE)
  from <- assert_and_convert_integerish(ceiling(from))
  to <- assert_and_convert_integerish(floor(to))
  if (from > to) {
    return(numeric(0))
  }
  checkmate::assert_true(to > -Inf && from < Inf)
  if (is.finite(from) && is.finite(to)) {
    representative <- from
    n_left <- 0L
    n_right <- to - from
  } else if (!is.finite(from) && is.finite(to)) {
    representative <- to
    n_left <- Inf
    n_right <- 0L
  } else if (is.finite(from) && !is.finite(to)) {
    representative <- from
    n_left <- 0L
    n_right <- Inf
  } else {
    representative <- 0L
    n_left <- Inf
    n_right <- Inf
  }
  x <- arithmetic(
    spacing = 1L,
    representative = representative,
    n_left = n_left,
    n_right = n_right
  )
  # Special class for printing only
  class(x) <- c("dsct_integer", class(x))
  attr(x, "name") <- "Integer"
  x
}
