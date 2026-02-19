#' @export
has_discretes.dsct_inverse <- function(x,
                                       values,
                                       ...,
                                       tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  if (!length(values)) {
    return(logical())
  }
  base <- x$base
  res <- rep_len(FALSE, length(values))
  is_na <- is.na(values)
  is_inf <- is.infinite(values)
  is_zro <- abs(values) <= tol
  res[is_na] <- NA
  res[which(values == -Inf)] <- has_negative_zero(base)
  res[which(values == Inf)] <- has_positive_zero(base)
  res[which(is_zro)] <- any(has_discretes(base, values = c(-Inf, Inf)))
  remaining_idx <- which(!(is_na | is_inf | is_zro))
  mapped <- 1 / values[remaining_idx]
  res[remaining_idx] <- has_discretes(base, values = mapped, tol = tol)
  res
}
