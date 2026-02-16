#' @export
has_negative_zero.dsct_union <- function(x) {
  series <- x$inputs
  any(vapply(series, has_negative_zero, FUN.VALUE = logical(1)))
}

#' @export
has_positive_zero.dsct_union <- function(x) {
  series <- x$inputs
  any(vapply(series, has_positive_zero, FUN.VALUE = logical(1)))
}

