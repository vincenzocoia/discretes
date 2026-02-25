#' @export
dsct_linear.numeric <- function(x, m, b = NULL) {
  checkmate::assert_numeric(m, finite = TRUE, any.missing = FALSE)
  checkmate::assert_numeric(
    b,
    finite = TRUE,
    any.missing = FALSE,
    null.ok = TRUE
  )
  if (length(m) > 1) {
    stop("`m` must be a vector of length 0 or 1, not length ", length(m), ".")
  }
  if (is.null(b)) {
    return(m * x)
  }
  if (length(b) > 1) {
    stop("`b` must be a vector of length 0 or 1, not length ", length(b), ".")
  }
  m * x + b
}
