#' @describeIn test_discrete Membership test for arithmetic progressions.
#' @param tol Numerical tolerance used when checking whether values align with
#'   the progression.
#' @export
test_discrete.arithmetic_infvctr <- function(x, values, ..., tol = 1e-12) {
  ellipsis::check_dots_empty()
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  checkmate::assert_number(tol, lower = 0, finite = TRUE)

  if (!length(values)) {
    return(logical())
  }

  rep_val <- x$representative
  spacing <- x$spacing

  indices <- (values - rep_val) / spacing
  is_integerish <- abs(indices - round(indices)) <= tol
  is_integerish[is.infinite(indices)] <- FALSE

  n_left <- -x$n_left
  n_right <- x$n_right

  is_integerish & (indices >= n_left - tol) & (indices <= n_right + tol)
}
