#' @export
test_discrete.dsct_transform <- function(x,
                                         values,
                                         ...,
                                         tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (!length(values)) {
    return(logical())
  }
  res <- rep_len(FALSE, length(values))
  is_na <- is.na(values)
  res[is_na] <- NA
  if (all(is_na)) {
    return(res)
  }
  rng <- x[["range"]]
  idx <- !is_na & values >= rng[1] & values <= rng[2]
  vals <- values[idx]
  base_values <- x[["inv"]](vals)
  res[idx] <- test_discrete(x[["base"]], values = base_values, tol = tol, ...)
  res
}
