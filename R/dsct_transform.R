#' Monotonic Transformation of discretes
#'
#' @param x A discretes object.
#' @param fun,inv A vectorized, strictly increasing function to apply to the
#'   discrete support values, and its inverse, `inv`.
#' @returns A transformed discretes object.
#' @note The onus is on the user to ensure that `inv` is indeed the inverse of
#'   `fun`, that both are vectorized, and that both are strictly increasing.
#' @examples
#' dsct_transform(integers(), fun = exp, inv = log)
#' @noRd
#' @export
dsct_transform <- function(x, fun, inv) {
  UseMethod("dsct_transform")
}

#' @noRd
#' @export
dsct_transform.discretes <- function(x, fun, inv) {
  checkmate::assert_function(fun)
  checkmate::assert_function(inv)
  new_discretes(
    data = list(base = x, fun = fun, inv = inv),
    name = "Transformed",
    subclass = "dsct_transform"
  )
}
