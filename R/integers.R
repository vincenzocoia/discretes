#' Integers
#'
#' Create an object representing the set of integers within a specified range.
#' @param from,to Numeric values defining the inclusive range of integers.
#' Defaults to `-Inf` and `Inf`, representing all integers.
#' @returns An object of class `integers_infvctr` (and `arithmetic_infvctr`,
#'   `infvctr`), representing the set of integers within the specified range.
#' @examples
#' integers()          # All integers
#' integers(from = 0) # Non-negative integers
#' integers(to = 0)   # Non-positive integers
#' integers(from = -5, to = 5) # Integers from -5
#' @export
integers <- function(from = -Inf, to = Inf) {
  checkmate::assert_number(from, finite = FALSE)
  checkmate::assert_number(to, lower = from, finite = FALSE)
  if (is.finite(from)) {
    checkmate::assert_integerish(from, tol = 0)
  }
  if (is.finite(to)) {
    checkmate::assert_integerish(to, tol = 0)
  }
  checkmate::assert_true(to > -Inf && from < Inf)

  if (is.finite(from) && is.finite(to)) {
    representative <- from
    n_left <- 0
    n_right <- to - from
  } else if (!is.finite(from) && is.finite(to)) {
    representative <- to
    n_left <- Inf
    n_right <- 0
  } else if (is.finite(from) && !is.finite(to)) {
    representative <- from
    n_left <- 0
    n_right <- Inf
  } else {
    representative <- 0
    n_left <- Inf
    n_right <- Inf
  }

  x <- arithmetic(
    spacing = 1,
    representative = representative,
    n_left = n_left,
    n_right = n_right
  )
  class(x) <- c("integers_infvctr", class(x))
  x
}

#' @export
print.integers_infvctr <- function(x, ...) {
  cat("Integers\n")
  NextMethod("print")
}
