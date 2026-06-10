#' Number of discrete values in a series
#'
#' Return the number of discrete values in `x` that lie between
#' `from` and `to`, or test whether the number of discrete values is infinite.
#' @inheritParams next_discrete
#' @param from,to Reference values, possibly infinite; both must be length-1
#'   numeric vectors. If `to < from`, the range is empty: `num_discretes()`
#'   returns `0` with a warning.
#' @param include_from,include_to Should the `from` value be included
#'   in the query? Should the `to` value? Both must be length-1 logical vectors.
#' @returns For `num_discretes()`,
#'   a single non-negative integer, or possibly `Inf` for infinitely many
#'   discrete values.
#' @examples
#' num_discretes(-3:3)
#' num_discretes(c(0.4, 0.4, 0.4, 0))
#'
#' x <- arithmetic(-3.2, spacing = 0.5)
#' num_discretes(x)
#' num_discretes(x, from = -2, to = 2)
#' num_discretes(1 / x, from = -2, to = 2)
#' @rdname num_discretes
#' @export
num_discretes <- function(x,
                          from = -Inf,
                          to = Inf,
                          ...,
                          include_from = TRUE,
                          include_to = TRUE,
                          tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  checkmate::assert_number(to)
  if (to < from) {
    warning(
      "`to` (", to, ") is less than `from` (", from,
      "); returning 0 for the empty range."
    )
    return(0L)
  }
  UseMethod("num_discretes")
}
