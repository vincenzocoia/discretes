#' Wrap a numeric vector as a discrete set.
#' 
#' The discretes package is careful to distinguish between how a discrete set
#' is encoded vs. how it's expressed (through, for example, `next_discrete()`).
#' This function allows a discrete set to be encoded by a numeric vector.
#' @param x A numeric vector with no missing values. May contain `Inf` and
#'   `-Inf`.
#' @returns A "discretes" object whose members are the unique values of `x`.
#' @details
#' This function is useful, for example, when doing
#'   `0 * dsct_union(integers(), -0)` -- it would be awkward to simplify this
#'   to `c(0, -0)`, yet both signed zeroes would need to be encoded in the
#'   resulting discrete set.
#' 
#' This function also ensures that manipulations remain pure: manipulating
#'   a discrete set returns a new discrete set.
#' @noRd
dsct_numeric <- function(x) {
  checkmate::assert_numeric(x, any.missing = FALSE, finite = FALSE)
  new_discretes(
    data = list(values = x),
    name = "Numeric vector",
    subclass = "dsct_numeric"
  )
}

#' @noRd
#' @export
num_discretes.dsct_numeric <- function(x,
                                       ...,
                                       from = -Inf,
                                       to = Inf,
                                       include_from = TRUE,
                                       include_to = TRUE,
                                       tol = sqrt(.Machine$double.eps)) {
  num_discretes(
    x = x$values,
    ...,
    from = from,
    to = to,
    include_from = include_from,
    include_to = include_to,
    tol = tol
  )
}

#' @noRd
#' @export
next_discrete.dsct_numeric <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = TRUE,
                                       tol = sqrt(.Machine$double.eps)) {
  next_discrete(
    x = x$values,
    from = from,
    ...,
    n = n,
    include_from = include_from,
    tol = tol
  )
}

#' @noRd
#' @export
prev_discrete.dsct_numeric <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = TRUE,
                                       tol = sqrt(.Machine$double.eps)) {
  prev_discrete(
    x = x$values,
    from = from,
    ...,
    n = n,
    include_from = include_from,
    tol = tol
  )
}

#' @noRd
#' @export
test_discrete.dsct_numeric <- function(x,
                                       values,
                                       ...,
                                       tol = sqrt(.Machine$double.eps)) {
  test_discrete(x$values, values = values, ..., tol = tol)
}

#' @noRd
#' @export
representative.dsct_numeric <- function(x) {
  representative(x$values)
}

#' @noRd
#' @export
has_negative_zero.dsct_numeric <- function(x) {
  has_negative_zero(x$values)
}

#' @noRd
#' @export
has_positive_zero.dsct_numeric <- function(x) {
  has_positive_zero(x$values)
}