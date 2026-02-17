#' @export
test_discrete.dsct_arithmetic <- function(x,
                                          values,
                                          ...,
                                          tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  if (!length(values)) {
    return(logical())
  }

  rep_val <- x$representative
  spacing <- x$spacing

  indices <- (values - rep_val) / spacing
  is_integerish <- abs(indices - round(indices)) < tol
  is_integerish[is.infinite(indices)] <- FALSE

  i_integerish <- which(is_integerish)
  indices[i_integerish] <- round(indices[i_integerish])
  above_left <- indices >= -x$n_left
  below_right <- indices <= x$n_right

  is_integerish & above_left & below_right
}
