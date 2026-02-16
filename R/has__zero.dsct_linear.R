#' @export
has_negative_zero.dsct_linear <- function(x) {
  zros <- zeroes_vector(x$base)
  b <- x[["b"]]
  if (is.null(b)) {
    trans <- zros * x[["m"]]
  } else {
    trans <- zros * x[["m"]] + b
  }
  has_negative_zero(trans)
}

#' @export
has_positive_zero.dsct_linear <- function(x) {
  zros <- zeroes_vector(x$base)
  b <- x[["b"]]
  if (is.null(b)) {
    trans <- zros * x[["m"]]
  } else {
    trans <- zros * x[["m"]] + b
  }
  has_positive_zero(trans)
}

