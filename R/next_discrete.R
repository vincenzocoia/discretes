#' Probing discrete values in a distribution
#'
#' `next_discrete()` and `prev_discrete()` find the `n` discrete values
#' in a distribution next to a reference point. `num_discretes()` finds
#' the number of discrete values within a range. `has_infinite_discretes()`
#' checks whether there are an infinite amount of discrete values between
#' a range of values.
#'
#' @param x Vector or discretes.
#' @param from,to Reference values.
#' @param ... Arguments to pass to other methods.
#' @param n Number of discrete values to find.
#' @param include_from,include_to Logical; should the `from` value be included
#' in the query? Should the `to` value?
#' @return For `next_discrete()` and `prev_discrete()`, a vector of
#' all available discrete points satisfying the query.
#' If less values are available than asked
#' via `n`, only those values are returned.
#' If infinite values satisfy the query, an error is thrown;
#' `NaN` occurs when no one particular discrete value follows, such as
#' when asking for the integer that comes before infinity.
#'
#' For `num_discretes()`, a single non-negative integer, possibly infinite.
#' Possibly also `NA_integer_` if there's not enough information to
#' determine this.
#'
#' For `has_infinite_discretes()`, a single logical, possibly `NA` if
#' there's not enough information to determine this.
#' @examples
#' x <- discretes(from = 2, to = Inf)
#' next_discrete(dst_pois(1), from = 1.3)
#' prev_discrete(dst_pois(1), from = 3, n = 10)
#' next_discrete(dst_norm(0, 1), from = 1.3, n = 4)
#' @rdname next_discrete
#' @export
next_discrete <- function(x, from, ..., n = 1L, include_from = FALSE) {
  UseMethod("next_discrete")
}

#' @export
#' @inheritParams next_discrete
next_discrete.discretes <- function(x, from, ..., n = 1L, include_from = FALSE) {
  stop("Don't know how to walk forwards on this series.")
}

