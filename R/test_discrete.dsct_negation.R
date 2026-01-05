#' @noRd
#' @export
test_discrete.dsct_negation <- function(x,
                                        values,
                                        ...,
                                        tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  checkmate::assert_number(tol, lower = 0)
  test_discrete(x$base, values = -values, tol = tol, ...)
}
