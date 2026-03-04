#' Traversing a numeric series
#'
#' `next_discrete()` and `prev_discrete()` find the `n` discrete values
#' in a numeric series next to a reference point. `num_discretes()` finds
#' the number of discrete values within a range.
#'
#' @param x Numeric series
#'   (`numeric` vector or object of class `"discretes"`).
#' @param from Reference value to start searching from; single numeric.
#' @param ... Reserved for future extensions; must be empty.
#' @param n Number of discrete values to find; single positive integer.
#' @param include_from Should the `from` value be included
#' in the query? Single logical; defaults to `TRUE`.
#' @param tol Numerical tolerance used for snapping queried values
#'   to discrete values in the numeric series; single non-negative numeric.
#' @returns A vector of sequential points starting from `from`, which is
#' included in the vector if it is a discrete value in the numeric series and
#' `include_from = TRUE`. The length of the vector is at most `n`, and
#' will return an empty numeric vector if there is no such discrete
#' value. `next_discrete()` is increasing, while `prev_discrete()` is
#' decreasing, so that earlier values are encountered sooner.
#' @note Just because there may not be any
#' @examples
#' x <- integers(from = 2)
#' next_discrete(x, from = 1.3)
#' prev_discrete(x, from = 4, n = 10)
#' next_discrete(x - 0.7, from = 1.3, n = 4)
#' @rdname next_discrete
#' @export
next_discrete <- function(x,
                          from,
                          ...,
                          n = 1L,
                          include_from = FALSE,
                          tol = sqrt(.Machine$double.eps)) {
  UseMethod("next_discrete")
}

#' @export
next_discrete.discretes <- function(x,
                                    from,
                                    ...,
                                    n = 1L,
                                    include_from = FALSE,
                                    tol = sqrt(.Machine$double.eps)) {
  stop("Don't know how to walk forwards on this series.")
}

