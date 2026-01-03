#' @rdname linear_transform
#' @export
dsct_negate <- function(x) {
  UseMethod("dsct_negate")
}

#' @describeIn linear_transform Negate a discretes object.
#' @export
dsct_negate.discretes <- function(x) {
  new_discretes(list(base = x), subclass = "dsct_negate")
}

#' @export
print.dsct_negation <- function(x, ...) {

}
