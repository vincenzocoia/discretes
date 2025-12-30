#' @export
next_discrete.arithmetic_infvctr <- function(x, from, ..., n = 1, include_from = TRUE) {
  checkmate::assert_numeric(from, len = 1)
  checkmate::assert_integerish(n, lower = 0, len = 1)
  checkmate::assert_logical(include_from, len = 1)
  ellipsis::check_dots_empty()
  if (from == Inf) {
    return(numeric(0L))
  }
  lower <- x$representative - x$spacing * x$n_left
  upper <- x$representative + x$spacing * x$n_right
  if (from < lower) {
    from <- lower
    include_from <- TRUE
  }
  if (from == -Inf) {
    # Also lower = -Inf in this case because of the previous if statement.
    stop("No defined next value when searching behind an infinite series.")
  }
  floor_from <- floor(from)
  adjust <- from == floor_from && include_from
  if (n == 0) {
    return(numeric(0L))
  }
  res <- floor_from + seq_len(n) - adjust
  res[res <= upper]
}
