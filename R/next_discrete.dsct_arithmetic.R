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
    type <- typeof(representative(x))
    return(vector(type, 0L))
  }
  if (from == -Inf && is.infinite(n_left)) {
    type <- typeof(representative(x))
    return(vector(type, 0L))
  }
  n_left <- x$n_left
  n_right <- x$n_right
  representative <- x$representative
  spacing <- x$spacing
  from_index <- (from - representative) / spacing
  if (from_index < -n_left) {
    from_index <- -n_left
    include_from <- TRUE
  }
  round_index <- ceiling2(from_index, tol = tol)
  if (abs(round_index - from_index) > tol) {
    include_from <- TRUE
  }
  candidate_indices <- from_index + seq_len(n) - round_index
  indices <- candidate_indices[candidate_indices <= n_right]
  representative + indices * spacing
}
