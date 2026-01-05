#' @noRd
#' @export
next_discrete.dsct_arithmetic <- function(x,
                                          from,
                                          ...,
                                          n = 1,
                                          include_from = TRUE,
                                          tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (from == Inf || n == 0) {
    return(numeric(0L))
  }
  n_left <- x$n_left
  n_right <- x$n_right
  representative <- x$representative
  spacing <- x$spacing
  if (spacing == 0) {
    n_left <- 0
    n_right <- 0
    spacing <- 1
  }
  if (is.infinite(n_left) && from == -Inf) {
    return(numeric(0))
  }
  from_index <- (from - representative) / spacing
  round_index <- round(from_index)
  if (abs(round_index - from_index) <= tol) {
    from_index <- round_index
  } else {
    from_index <- ceiling(from_index)
    include_from <- TRUE
  }
  if (from_index < n_left) {
    from_index <- n_left
    include_from <- TRUE
  }
  candidate_indices <- from_index + seq_len(n) - include_from
  indices <- candidate_indices[candidate_indices <= n_right]
  representative + indices * spacing
}
