#' @export
next_discrete.dsct_keep <- function(
  x,
  from,
  ...,
  n = 1L,
  include_from = TRUE,
  tol = sqrt(.Machine$double.eps)
) {
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
  if (abs(from - l) <= tol && include_from) {
    from <- l
    include_from <- include_left
  }
  if (from < l - tol) {
    from <- l
    include_from <- include_right
  }
  res <- next_discrete(
    base,
    from = from,
    n = n,
    include_from = include_from,
    tol = tol
  )
  if (include_right) {
    res <- res[res <= r]
  } else {
    res <- res[res < r]
  }
  res
}
