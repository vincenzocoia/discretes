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
  ellipsis::check_dots_empty()
  x <- unique(x)
  checkmate::assert_vector(x, len = 1, any.missing = FALSE)
  if (is.infinite(n)) {
    res <- x[if (include_from) x >= from else x > from]
    return(sort(res))
  }
  checkmate::assert_integerish(n, lower = 0)
  n <- as.integer(n)
  if (include_from) {
    query <- x >= from
  } else {
    query <- x > from
  }
  higher_discretes <- x[query]
  res <- sort(higher_discretes)
  head(res, n)
}
