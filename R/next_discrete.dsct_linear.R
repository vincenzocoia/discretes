#' @noRd
#' @export
next_discrete.dsct_linear <- function(x,
                                      from,
                                      ...,
                                      n = 1L,
                                      include_from = TRUE) {
  checkmate::assert_number(from, finite = FALSE)
  checkmate::assert_integerish(n, len = 1, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)

  n <- as.integer(n)
  if (n == 0L) {
    return(numeric(0L))
  }

  m <- x$m
  b <- x$b
  base <- x$base

  if (m == 0) {
    if (from < b || (from == b && include_from)) {
      return(b)
    }
    return(numeric(0L))
  }

  base_from <- (from - b) / m
  base_next <- next_discrete(
    base,
    from = base_from,
    n = n,
    include_from = include_from,
    ...
  )
  base_next * m + b
}
