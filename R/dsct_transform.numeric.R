#' @export
dsct_transform.numeric <- function(x, fun, ...) {
  checkmate::assert_function(fun)
  fun(x)
}
