#' @export
next_discrete.dsct_arithmetic <- function(x,
                                          from,
                                          ...,
                                          n = 1,
                                          include_from = TRUE) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  checkmate::assert_integerish(n, lower = 0, len = 1)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  if (from == Inf || n == 0) {
    return(numeric(0L))
  }

  n_left <- x$n_left
  n_right <- x$n_right
  representative <- x$representative
  spacing <- x$spacing
  lowest <- representative - n_left * spacing
  highest <- representative + n_right * spacing

  if (from < lowest) {
    from <- lowest
    include_from <- TRUE
  }

  raw_index <- (from - representative) / spacing
  start_index <- ceiling(raw_index)
  candidate_indices <- start_index + seq_len(n) - include_from
  indices <- candidate_indices[candidate_indices <= n_right]
  representative + indices * spacing
}
