#' Reciprocal Series
#'
#' Take the reciprocal of values in a series of discretes.
#' @param x Discretes object.
#' @returns A new series of discretes containing the reciprocals of all values
#'   in `x`.
#' @noRd
#' @export
dsct_invert <- function(x) {
  UseMethod("dsct_invert")
}

#' @noRd
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
