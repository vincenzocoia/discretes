#' @noRd
#' @export
dsct_transform.dsct_transform <- function(x, fun, inv) {
  checkmate::assert_function(fun)
  checkmate::assert_function(inv)
  old_fun <- x$fun
  old_inv <- x$inv
  new_fun <- function(values) {
    fun(old_fun(values))
  }
  new_inv <- function(values) {
    old_inv(inv(values))
  }
  dsct_transform(x$base, fun = new_fun, inv = new_inv)
}
