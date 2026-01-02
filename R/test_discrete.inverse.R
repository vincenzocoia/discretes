#' @describeIn test_discrete Membership test for reciprocal transforms.
#' @export
test_discrete.inverse <- function(x, values, ...) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)

  if (!length(values)) {
    return(logical(0L))
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
  res[valid_idx] <- test_discrete(x$base, mapped, ...)
  res
}
