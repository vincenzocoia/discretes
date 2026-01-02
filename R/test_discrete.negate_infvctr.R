#' @describeIn test_discrete Membership test for negated infvctr objects.
#' @export
test_discrete.negate_infvctr <- function(x, values, ...) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  test_discrete(x$base, -values, ...)
}
