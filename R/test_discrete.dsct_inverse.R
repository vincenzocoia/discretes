#' @noRd
#' @export
test_discrete.dsct_inverse <- function(x,
                                       values,
                                       ...,
                                       tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  if (!length(values)) {
    return(logical())
  }

  res <- rep_len(FALSE, length(values))
  is_na <- is.na(values)
  is_inf <- is.infinite(values)
  res[is_na] <- NA

  valid_idx <- which(!(is_na | is_inf))
  if (!length(valid_idx)) {
    return(res)
  }

  val_subset <- values[valid_idx]
  mapped <- 1 / val_subset
  res[valid_idx] <- test_discrete(x$base, values = mapped, tol = tol)
  res
}
