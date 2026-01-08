#' @noRd
#' @export
test_discrete.dsct_union <- function(x,
                                     values,
                                     ...,
                                     tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  inputs <- x$inputs
  if (!length(values)) {
    return(logical())
  }
  tests <- lapply(inputs, function(d) {
    test_discrete(d, values = values, tol = tol)
  })
  Reduce(`|`, tests)  # Proper handling of NA is automatic.
}
