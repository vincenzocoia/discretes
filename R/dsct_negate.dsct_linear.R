#' @export
dsct_negate.dsct_linear <- function(x) {
  old_m <- x[["m"]]
  old_b <- x[["b"]]
  if (is.null(old_b)) {
    b <- NULL
  } else {
    b <- -old_b
  }
  dsct_linear(
    x = x[["base"]],
    m = -old_m,
    b = b
  )
}