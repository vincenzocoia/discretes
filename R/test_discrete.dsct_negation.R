#' @describeIn test_discrete Membership test for negated discrete objects.
#' @export
test_discrete.dsct_negate <- function(x, values, ...) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  test_discrete(x$base, -values, ...)
}
