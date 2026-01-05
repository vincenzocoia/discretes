#' Integer Discrete Values
#'
#' Create a "discretes" object representing the set of integers within a
#' specified range.
#' @param from,to Numeric values defining the inclusive range of integers.
#' Defaults to `-Inf` and `Inf`, representing all integers.
#' @returns A "discretes" object of class `dsct_integers`,
#'   representing the set of integers within the specified range.
#' @examples
#' integers()                  # All integers
#' integers(from = 0)          # Non-negative integers
#' integers(to = 1.5)          # Ends at 1.
#' integers(from = -5, to = 5) # Integers from -5 to 5.
#' @export
integers <- function(from = -Inf, to = Inf) {
  checkmate::assert_number(from, finite = FALSE)
  checkmate::assert_number(to, lower = from, finite = FALSE)
  from <- as.integer(ceiling(from))
  to <- as.integer(floor(to))
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
  class(x) <- c("dsct_integer", class(x))
  attr(x, "name") <- "Integer"
  x
}
