#' @noRd
#' @export
prev_discrete.dsct_arithmetic <- function(x,
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
  if (from == -Inf || n == 0) {
    type <- typeof(representative(x))
    return(vector(type, 0L))
  }
  n_left <- x$n_left
  n_right <- x$n_right
  representative <- x$representative
  spacing <- x$spacing
  if (spacing == 0) {
    n_left <- 0L
    n_right <- 0L
    spacing <- 1L
  }
  if (from == Inf && is.infinite(n_right)) {
    type <- typeof(representative(x))
    return(vector(type, 0L))
  }
  from_index <- (from - representative) / spacing
  if (from_index > n_right) {
    from_index <- n_right
    include_from <- TRUE
  }
  round_index <- round(from_index)
  if (abs(round_index - from_index) <= tol) {
    from_index <- round_index
  } else {
    from_index <- floor(from_index)
    include_from <- TRUE
  }
  from_index <- as.integer(from_index)
  candidate_indices <- from_index - (seq_len(n) - include_from)
  indices <- candidate_indices[candidate_indices >= -n_left]
  representative + indices * spacing
}
