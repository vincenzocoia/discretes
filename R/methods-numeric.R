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
#' @rdname numeric
#' @export
next_discrete.numeric <- function(x, from, ..., n = 1, include_from = FALSE) {
  x <- unique(x)
  if (include_from) {
    query <- x >= from
  } else {
    query <- x > from
  }
  higher_discretes <- x[query]
  n <- min(length(higher_discretes), n)
  sort(higher_discretes)[seq_len(n)]
}

#' @rdname numeric
#' @export
prev_discrete.numeric <- function(x, from, ..., n = 1, include_from = FALSE) {
  x <- unique(x)
  if (include_from) {
    query <- x <= from
  } else {
    query <- x < from
  }
  lower_discretes <- x[query]
  n <- min(length(lower_discretes), n)
  sort(lower_discretes, decreasing = TRUE)[seq_len(n)]
}

#' @export
num_discretes.numeric <- function(x,
                                  from,
                                  to,
                                  ...,
                                  include_from = TRUE,
                                  include_to = TRUE) {
  x <- unique(x)
  if (include_from) {
    left_query <- x >= from
  } else {
    left_query <- x > from
  }
  if (include_to) {
    right_query <- x <= to
  } else {
    right_query <- x < to
  }
  sum(left_query & right_query)
}

#' @export
has_infinite_discretes.numeric <- function(x, from, to) {
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  FALSE
}
