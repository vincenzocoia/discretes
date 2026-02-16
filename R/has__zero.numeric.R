#' @export
has_negative_zero.numeric <- function(x) {
  -Inf %in% (1 / x)
}

#' @export
has_positive_zero.numeric <- function(x) {
  Inf %in% (1 / x)
}

