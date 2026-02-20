#' Extract members of a discrete set
#' 
#' Extract a finite subset of values from a discrete set by asking for
#' specific values (`get_discretes_at()`) or by setting a range
#' (`pluck_between()`). For `get_discretes_at()`, specified values "snap" to
#' those in the discrete set if they are within `tol` of a value.
#' @param values Numeric vector of values to pull from the discrete set `x`.
#' @rdname get_discretes
#' @export
get_discretes_at <- function(x, values, ..., tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discrete_set(x))
  checkmate::assert_numeric(values, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  has <- has_discretes(x, values = values, tol = tol, ...)
  values <- values[has]
  # id0 <- which(res == 0)
  # if (has_positive_zero(x)) {
  #   zro <- 0
  # } else {
  #   zro <- -0
  # }
  # res[id0] <- zro
  type <- typeof(representative(x))
  vapply(
    values,
    function(v) next_discrete(x, v, include_from = TRUE, tol = tol),
    FUN.VALUE = vector(mode = type, length = 1L)
  )
}