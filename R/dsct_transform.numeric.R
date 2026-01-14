#' @noRd
#' @export
dsct_transform.numeric <- function(x, fun, inv) {
  checkmate::assert_function(fun)
  checkmate::assert_function(inv)
  fun(x)
}
