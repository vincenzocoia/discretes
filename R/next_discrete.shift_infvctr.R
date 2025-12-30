#' @export
#' @inheritParams next_discrete
next_discrete.shift_infvctr <- function(x, from, ..., n = 1L, include_from = TRUE) {
  ellipsis::check_dots_empty()
  shift <- x$shift
  base <- x$base
  shifted_from <- from - shift
  next_discrete(
    base,
    from = shifted_from,
    n = n,
    include_from = include_from
  ) + shift
}
