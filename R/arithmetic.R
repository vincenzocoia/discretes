#' Arithmetic series
#'
#' Construct an arithmetic progression, with possibly infinite values.
#' The progression is anchored at `representative` and extends `n_left` steps
#' to the left (decreasing values) and `n_right` steps to the right
#' (increasing values) with constant `spacing` between consecutive terms.
#'
#' @param representative Numeric scalar giving a known term in the progression.
#' @param spacing Non-negative numeric scalar describing the distance between
#'   adjacent terms.
#' @param ... Reserved for future extensions; must be empty.
#' @param n_left,n_right Non-negative counts (possibly `Inf`, the default)
#'   describing how many steps exist to the left and right of `representative`.
#' @returns A numeric series (class `dsct_arithmetic`, inheriting from
#'   `discretes`).
#' @note While `spacing` can be zero, this results in a numeric series
#'   containing only the `representative` value as its single discrete value.
#'  
#' The series can only contain `-0` if the `representative` is set as such. 
#' @examples
#' arithmetic(representative = -0.6, spacing = 0.7)
#' arithmetic(representative = 0.6, spacing = 0.7, n_right = 0)
#' arithmetic(representative = 0, spacing = 2, n_left = 2, n_right = 2)
#' 
#' # Negative zero, resulting in `-Inf` upon inversion:
#' has_negative_zero(arithmetic(-0, 1))
#' @seealso [integers()]
#' @export
arithmetic <- function(representative,
                       spacing,
                       ...,
                       n_left = Inf,
                       n_right = Inf) {
  checkmate::assert_number(representative)
  checkmate::assert_number(spacing, lower = 0)
  ellipsis::check_dots_empty()
  n_left <- assert_and_convert_integerish(n_left, lower = 0)
  n_right <- assert_and_convert_integerish(n_right, lower = 0)
  if (spacing == 0 || (n_left == 0 && n_right == 0)) {
    return(as_discretes(representative))
  }
  type <- typeof(representative + spacing)
  mode(representative) <- type
  mode(spacing) <- type
  location <- numeric()
  direction <- numeric()
  if (is.infinite(n_right)) {
    location <- c(location, Inf)
    direction <- c(direction, -1)
  }
  if (is.infinite(n_left)) {
    location <- c(location, -Inf)
    direction <- c(direction, 1)
  }
  new_discretes(
    data = list(
      representative = representative,
      spacing = spacing,
      n_left = n_left,
      n_right = n_right
    ),
    name = "Arithmetic",
    sinks = sinks_matrix(location = location, direction = direction),
    subclass = "dsct_arithmetic"
  )
}
