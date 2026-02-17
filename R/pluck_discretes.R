#' Extract members of a discrete set
#' 
#' Extract a finite subset of values from a discrete set by asking for
#' specific values (`pluck_discretes()`) or by setting a range
#' (`pluck_between()`). For `pluck_discretes()`, specified values "snap" to
#' those in the discrete set if they are within `tol` of a value.
#' 
#' @export
pluck_discretes <- function(x, values, ..., tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discretes(x))
  checkmate::assert_numeric(values, any.missing = FALSE)
  has <- test_discrete(x, values = values, tol = tol, ...)
  res <- values[has]
  id0 <- which(res == 0)
  if (has_positive_zero(x)) {
    zro <- 0
  } else {
    zro <- -0
  }
  res[id0] <- zro
  res
}