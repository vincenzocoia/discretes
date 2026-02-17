#' @export
dsct_linear.numeric <- function(x, m, b = NULL) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE, null.ok = TRUE)
  if (is.null(b)) {
    res <- m * x
  } else {
    res <- m * x + b
  }
  if (any(is.na(res))) {
    stop(
      "Values not allowed from transformation: ",
      paste(unique(res[is.na(res)]), collapse = ", ")
    )
  }
  res
}
