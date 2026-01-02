#' @describeIn test_discrete Membership test for linear transforms.
#' @export
test_discrete.linear_transform <- function(x, values, ...) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  m <- x$m
  b <- x$b
  res <- rep_len(FALSE, length(values))
  is_na <- is.na(values)
  res[is_na] <- NA
  if (all(is_na)) {
    return(res)
  }
  idx <- !is_na
  if (m == 0) {
    res[idx] <- values[idx] == b
    return(res)
  }
  base_values <- (values[idx] - b) / m
  res[idx] <- test_discrete(x$base, base_values, ...)
  res
}
