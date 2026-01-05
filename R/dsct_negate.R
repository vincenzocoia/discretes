#' @noRd
dsct_negate <- function(x) {
  UseMethod("dsct_negate")
}

#' @noRd
#' @exportS3Method
dsct_negate.discretes <- function(x) {
  new_discretes(
    list(base = x),
    name = "Negated",
    subclass = "dsct_negate"
  )
}
