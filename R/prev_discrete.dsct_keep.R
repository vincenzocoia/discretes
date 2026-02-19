#' @export
prev_discrete.dsct_keep <- function(x,
                                    from,
                                    ...,
                                    n = 1L,
                                    include_from = FALSE,
                                    tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  base <- x$base
  l <- x$left
  r <- x$right
  include_left <- x$include_left
  include_right <- x$include_right
  same_right <- is.infinite(from) && is.infinite(r) && sign(from) == sign(r)
  if ((same_right || abs(from - r) <= tol) && include_from) {
    from <- r
    include_from <- include_right
  }
  if (from > r + tol) {
    from <- r
    include_from <- include_right
  }
  res <- prev_discrete(
    base,
    from = from,
    n = n,
    include_from = include_from,
    tol = tol
  )
  if (include_left) {
    res <- res[res >= l]
  } else {
    res <- res[res > l]
  }
  res
}
