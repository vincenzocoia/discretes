#' @export
has_negative_zero.dsct_transform <- function(x) {
  zros <- zeroes_vector(x[["base"]])
  has_negative_zero(x[["fun"]](zros))
}

#' @export
has_positive_zero.dsct_transform <- function(x) {
  zros <- zeroes_vector(x[["base"]])
  has_positive_zero(x[["fun"]](zros))
}

