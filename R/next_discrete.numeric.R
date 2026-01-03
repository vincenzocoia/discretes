#' Discrete Values from Numeric Vectors
#'
#' @param x A numeric vector.
#' @inheritParams next_discrete
#' @returns A numeric vector.
#' @examples
#' x <- c(1.2, 1.2, 1.2, 5, -2.5, 3.4, 0, 7.8)
#' next_discrete(x, from = -100)
#' next_discrete(x, from = -100, n = 4)
#' next_discrete(x, from = -100, n = 10)
#' prev_discrete(x, from = 10)
#' num_discretes(x, from = 0, to = 5)
#' has_infinite_discretes(x, from = -Inf, to = Inf)
#' @name numeric_discretes
#' @rdname numeric_discretes
#' @export
next_discrete.numeric <- function(x, from, ..., n = 1, include_from = FALSE) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, any.missing = FALSE, len = 1)
  x <- unique(x)
  x <- x[!is.na(x)]
  if (include_from) {
    upper_discretes <- x[x >= from]
  } else {
    upper_discretes <- x[x > from]
  }
  upper_discretes <- sort(upper_discretes)
  head(upper_discretes, n)
}
