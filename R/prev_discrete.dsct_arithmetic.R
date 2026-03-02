#' @export
prev_discrete.dsct_arithmetic <- function(x,
                                          from,
                                          ...,
                                          n = 1,
                                          include_from = FALSE,
                                          tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (from == -Inf || n == 0) {
    type <- typeof_dsct(x)
    return(vector(type, 0L))
  }
  n_left <- x$n_left
  n_right <- x$n_right
  representative <- x$representative
  spacing <- x$spacing
  if (from == Inf && is.infinite(n_right)) {
    type <- typeof_dsct(x)
    return(vector(type, 0L))
  }
  from_index <- (from - representative) / spacing
  if (from_index > n_right) {
    from_index <- n_right
    include_from <- TRUE
  }
  round_index <- floor2(from_index, tol = tol)
  if (abs(round_index - from_index) > tol) {
    include_from <- TRUE
  }
  if (n == Inf) {
    if (n_left == Inf) {
      stop("Infinitely many values found; ensure `n` is finite here.")
    }
    n <- n_left + round_index + include_from
  }
  candidate_indices <- round_index - (seq_len(n) - include_from)
  indices <- candidate_indices[candidate_indices >= -n_left]
  res <- representative + indices * spacing
  if (representative == 0 && 0 %in% res) {
    res[res == 0] <- representative
  }
  res
}
