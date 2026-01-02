#' Number of Discrete Values in a Series
#'
#' Return the number of discrete values in `x` that lie between
#' `from` and `to`, or test whether the number of discrete values is infinite.
#' @param x Invctr object.
#' @param ... Reserved for future extensions; must be empty.
#' @param from,to Reference values, possibly infinite. `from` must be less than
#'   or equal to `to`; both must be length-1 numeric vectors.
#' @param include_from,include_to Logical; should the `from` value be included
#'   in the query? Should the `to` value? Both must be length-1 logical vectors.
#' @returns A single non-negative integer, or possibly `Inf` for infinitely many
#'   discrete values.
#' @examples
#' num_discretes(-3:3)
#' num_discretes(c(0.4, 0.4, 0.4, 0))
#'
#' x <- arithmetic(-3.2, spacing = 0.5)
#' num_discretes(x)
#' num_discretes(x, from = -2, to = 2)
#' num_discretes(1 / x, from = -2, to = 2)
#'
#' @rdname num_discretes
#' @export
num_discretes <- function(x,
                          ...,
                          from = -Inf,
                          to = Inf,
                          include_from = TRUE,
                          include_to = TRUE) {
  UseMethod("num_discretes")
}
