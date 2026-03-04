#' Invert a numeric series
#'
#' Create a numeric series by taking the reciprocal of discrete values in
#' another numeric series.
#' @inheritParams next_discrete
#' @returns A new numeric series whose discrete values are the reciprocals
#'   of the discrete values in `x`.
#' @noRd
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
