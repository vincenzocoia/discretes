#' @export
num_discretes.dsct_keep <- function(x,
                                    ...,
                                    from = -Inf,
                                    to = Inf,
                                    include_from = TRUE,
                                    include_to = TRUE,
                                    tol = sqrt(.Machine$double.eps)) {
  ellipsis::check_dots_empty()
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (from == to) {
    return(
      possibly_as_integer(
        include_from && include_to && has_discretes(x, values = from, tol = tol)
      )
    )
  }
  base <- x$base
  l <- x$left
  r <- x$right
  include_left <- x$include_left
  include_right <- x$include_right
  if (from > r + tol || to < l - tol) {
    return(0L)
  }
  if (from <= l + tol) {
    from <- l
    same_left <- is.infinite(from) && is.infinite(l) && sign(from) == sign(l)
    if (same_left || abs(from - l) <= tol) {
      include_from <- include_left && include_from
    } else {
      include_from <- include_left
    }
  }
  if (to >= r - tol) {
    to <- r
    same_right <- is.infinite(to) && is.infinite(r) && sign(to) == sign(r)
    if (same_right || abs(to - r) <= tol) {
      include_to <- include_right && include_to
    } else {
      include_to <- include_right
    }
  }
  num_discretes(
    base,
    from = from,
    to = to,
    include_from = include_from,
    include_to = include_to,
    tol = tol
  )
}
