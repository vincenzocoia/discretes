#' @noRd
#' @export
next_discrete.dsct_linear <- function(x,
                                      from,
                                      ...,
                                      n = 1L,
                                      include_from = TRUE,
                                      tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (n == 0) {
    return(numeric(0L))
  }

  m <- x$m
  b <- x$b
  base <- x$base

  if (m == 0) {
    proxy <- arithmetic(representative = b, spacing = 0)
    res <- next_discrete(
      proxy, from = from, n = n, include_from = include_from, tol = tol, ...
    )
    return(res)
  }

  base_from <- (from - b) / m
  base_next <- next_discrete(
    base,
    from = base_from,
    n = n,
    include_from = include_from,
    tol = tol,
    ...
  )
  base_next * m + b
}
