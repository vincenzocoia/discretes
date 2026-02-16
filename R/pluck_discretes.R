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