#' @noRd
#' @export
dsct_negate <- function(x) {
  UseMethod("dsct_negate")
}

#' @noRd
#' @export
dsct_negate.discretes <- function(x) {
  new_discretes(
    list(base = x),
    name = "Negated",
    sinks = -sinks(x),
    subclass = "dsct_negation"
  )
}
