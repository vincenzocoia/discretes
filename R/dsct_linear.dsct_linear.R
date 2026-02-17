#' @noRd
#' @export
dsct_linear.dsct_linear <- function(x, m, b = NULL) {
  checkmate::assert_numeric(m, any.missing = FALSE, len = 1)
  checkmate::assert_numeric(b, any.missing = FALSE, len = 1, null.ok = TRUE)
  old_m <- x[["m"]]
  old_b <- x[["b"]]
  base <- x[["base"]]
  new_m <- m * old_m
  # new_b has one term for each non-NULL b: (m * old_b + b)
  if (is.null(old_b) && is.null(b)) {
    new_b <- NULL
  }
  if (!is.null(old_b) && is.null(b)) {
    new_b <- m * old_b
  }
  if (is.null(old_b) && !is.null(b)) {
    new_b <- b
  }
  if (!is.null(old_b) && !is.null(b)) {
    new_b <- m * old_b + b
  }
  dsct_linear(base, m = new_m, b = new_b)
}
