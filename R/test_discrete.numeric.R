#' @noRd
#' @export
test_discrete.numeric <- function(x, values, ...) {
  ellipsis::check_dots_empty()
  checkmate::assert_atomic(values, any.missing = TRUE)
  res <- values %in% x
  res[is.na(values)] <- NA
  res
}

