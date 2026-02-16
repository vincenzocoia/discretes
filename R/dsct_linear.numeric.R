#' @noRd
#' @export
dsct_linear.numeric <- function(x, m, b) {
  checkmate::assert_number(m, finite = TRUE)
  checkmate::assert_number(b, finite = TRUE)
  if (missing(b)) {
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
