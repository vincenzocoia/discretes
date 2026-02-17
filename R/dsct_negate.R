#' Negate a Discrete Value Series
#' 
#' @param x Discrete value series
#'   (`numeric` vector or object of class `"discretes"`).
#' @family transformations
#' @export
dsct_negate <- function(x) {
  UseMethod("dsct_negate")
}

#' @export
dsct_negate.discretes <- function(x) {
  new_discretes(
    list(base = x),
    name = "Negated",
    sinks = -sinks(x),
    subclass = "dsct_negation"
  )
}