#' @noRd
#' @export
next_discrete.dsct_negation <- function(x,
                                      from,
                                      ...,
                                      n = 1L,
                                      include_from = TRUE,
                                      tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  -prev_discrete(
    x$base,
    from = -from,
    n = n,
    include_from = include_from,
    tol = tol,
    ...
  )
}
