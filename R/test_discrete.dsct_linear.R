#' @noRd
#' @export
test_discrete.dsct_linear <- function(x,
                                      values,
                                      ...,
                                      tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (!length(values)) {
    return(logical())
  }
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
    res[idx] <- abs(values[idx] - b) < tol
    return(res)
  }
  base_values <- (values[idx] - b) / m
  res[idx] <- test_discrete(x$base, values = base_values, tol = tol, ...)
  res
}
