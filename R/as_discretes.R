#' Convert to a discretes object
#' 
#' Convert a foreign object to a "discretes" object.
#'
#' @param x Object to convert to object of class "discretes".
#' @returns A numeric series (object of class `"discretes"`). When `x` is
#'   a numeric vector, the series contains all unique values of `x`.
#' @examples
#' as_discretes(0:10)
#' @export
as_discretes <- function(x) UseMethod("as_discretes")

#' @describeIn as_discretes Convert a numeric vector to discretes object.
#' @export
as_discretes.discretes <- function(x) {
  x
}

#' @describeIn as_discretes Keeps the discretes object as-is.
#' @export
as_discretes.numeric <- function(x) {
  checkmate::assert_numeric(x, any.missing = FALSE, finite = FALSE)
  new_discretes(
    data = list(values = x),
    name = "Numeric vector",
    subclass = "dsct_numeric"
  )
}

#' @export
num_discretes.dsct_numeric <- function(x,
                                       from = -Inf,
                                       to = Inf,
                                       ...,
                                       include_from = TRUE,
                                       include_to = TRUE,
                                       tol = sqrt(.Machine$double.eps)) {
  num_discretes(
    x = x[["values"]],
    from = from,
    to = to,
    include_from = include_from,
    include_to = include_to,
    tol = tol,
    ...
  )
}

#' @export
next_discrete.dsct_numeric <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = FALSE,
                                       tol = sqrt(.Machine$double.eps)) {
  next_discrete(
    x = x[["values"]],
    from = from,
    n = n,
    include_from = include_from,
    tol = tol,
    ...
  )
}

#' @export
prev_discrete.dsct_numeric <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = FALSE,
                                       tol = sqrt(.Machine$double.eps)) {
  prev_discrete(
    x = x[["values"]],
    from = from,
    n = n,
    include_from = include_from,
    tol = tol,
    ...
  )
}

#' @export
has_discretes.dsct_numeric <- function(x,
                                       values,
                                       ...,
                                       tol = sqrt(.Machine$double.eps)) {
  has_discretes(x[["values"]], values = values, tol = tol, ...)
}

#' @export
representative.dsct_numeric <- function(x) {
  representative(x[["values"]])
}

#' @export
has_negative_zero.dsct_numeric <- function(x) {
  has_negative_zero(x[["values"]])
}

#' @export
has_positive_zero.dsct_numeric <- function(x) {
  has_positive_zero(x[["values"]])
}