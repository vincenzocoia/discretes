#' @export
has_discretes.dsct_keep <- function(
  x,
  values,
  ...,
  tol = sqrt(.Machine$double.eps)
) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  if (!length(values)) {
    return(logical())
  }
  l <- x$left
  r <- x$right
  include_left <- x$include_left
  include_right <- x$include_right
  outside <- values < l - tol | values > r + tol
  bad_l <- !include_left & abs(values - l) <= tol
  bad_r <- !include_right & abs(values - r) <= tol
  layer1 <- !outside & !bad_l & !bad_r
  layer2 <- has_discretes(
    x$base,
    values = values,
    tol = tol
  )
  layer1 & layer2
}
