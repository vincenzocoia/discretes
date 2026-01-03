#' @noRd
#' @export
test_discrete.dsct_arithmetic <- function(x, values, ...) {
  ellipsis::check_dots_empty()
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)

  if (!length(values)) {
    return(logical())
  }

  rep_val <- x$representative
  spacing <- x$spacing

  indices <- (values - rep_val) / spacing
  is_integerish <- abs(indices - round(indices)) == 0
  is_integerish[is.infinite(indices)] <- FALSE

  n_left <- -x$n_left
  n_right <- x$n_right

  is_integerish & (indices >= n_left) & (indices <= n_right)
}
