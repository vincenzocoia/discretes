#' Invert a Discrete Value Series
#'
#' Create a discrete value series by taking the reciprocal of values in
#' another discrete value series.
#' @inheritParams dsct_negate
#' @returns A new discrete value series containing the reciprocals of all values
#'   in `x`.
#' @details
#' By default, this transformation creates a new `"dsct_inverse"` subclass by
#' wrapping the input object. Simplifications occur when behaviour is known,
#' for the following series:
#' 
#' - **Numeric vectors**: The reciprocal of each value is computed directly,
#'   returning another numeric vector.
#' - **Inverse series**: The inverse of an inverse series returns the original
#'   series.
#' @family transformations
#' @examples
#' dsct_invert()
#' 
#' @export
dsct_invert <- function(x) {
  UseMethod("dsct_invert")
}


#' @export
dsct_invert.discretes <- function(x) {
  base_sinks <- sinks(x)
  location <- base_sinks[, "location"]
  direction <- base_sinks[, "direction"]
  new_location <- 1 / location
  new_direction <- -direction
  is_zero <- location == 0
  new_location[is_zero] <- ifelse(direction[is_zero] > 0, Inf, -Inf)
  new_discretes(
    data = list(base = x),
    name = "Reciprocal",
    sinks = sinks_matrix(location = new_location, direction = new_direction),
    subclass = "dsct_inverse"
  )
}
