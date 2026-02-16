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
    return(vector(length = 0, mode = typeof(representative(x))))
  }
  base <- x$base
  m <- x[["m"]]
  b <- x[["b"]]
  if (is.null(b)) { # For use of b = 0 when signed 0 doesn't matter.
    bb <- 0
  } else {
    bb <- b
  }
  base_from <- (from - bb) / m
  base_next <- next_discrete(
    base,
    from = base_from,
    n = n,
    include_from = include_from,
    tol = tol,
    ...
  )
  if (is.null(b)) {
    return(base_next * m)
  }
  base_next * m + b
}
