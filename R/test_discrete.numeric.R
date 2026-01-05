#' @noRd
#' @export
test_discrete.numeric <- function(x,
                                  values,
                                  ...,
                                  tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  x <- unique(x)
  x <- x[!is.na(x)]
  vapply(
    values,
    FUN = function(v) {
      if (is.infinite(v)) {
        return(v %in% x)
      }
      diffs <- abs(v - x)
      min_diff <- min(diffs)
      min_diff < tol
    },
    FUN.VALUE = logical(1L)
  )
}

