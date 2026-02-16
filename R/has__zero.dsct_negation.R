#' @export
has_positive_zero.dsct_negation <- function(x) {
  if (typeof(representative(x)) == "integer") {
    return(TRUE)
  }
  has_negative_zero(x$base)
}

#' @export
has_negative_zero.dsct_negation <- function(x) {
  if (typeof(representative(x)) == "integer") {
    return(FALSE)
  }
  has_positive_zero(x$base)
}

