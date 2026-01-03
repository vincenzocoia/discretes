#' @noRd
#' @export
test_discrete.dsct_negation <- function(x, values, ...) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  test_discrete(x$base, -values, ...)
}
