#' @describeIn discretes Previous discrete values for negated discrete objects.
#' @export
#' @inheritParams prev_discrete
prev_discrete.dsct_negate <- function(x,
                                      from,
                                      ...,
                                      n = 1L,
                                      include_from = FALSE) {
  checkmate::assert_number(from, finite = FALSE)
  checkmate::assert_integerish(n, len = 1, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  -next_discrete(
    x$base,
    from = -from,
    n = n,
    include_from = include_from,
    ...
  )
}
