#' @export
test_discrete.arithmetic_infvctr <- function(x, values, ..., tol = 1e-15) {
  # If `values` is in the arithmetic sequence, then the following should be
  # integer.
  should_be_integers <- (values - x$representative) / x$spacing
  diffs <- abs(should_be_integers - floor(should_be_integers))
  diffs <= tol
}
