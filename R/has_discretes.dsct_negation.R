#' @export
has_discretes.dsct_negation <- function(x,
                                        values,
                                        ...,
                                        tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  checkmate::assert_number(tol, lower = 0)
  has_discretes(x$base, values = -values, tol = tol, ...)
}
