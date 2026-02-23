#' @export
has_positive_zero.dsct_negation <- function(x) {
  base <- x[["base"]]
  if (typeof(representative(x)) == "integer") {
    return(has_positive_zero(base))
  }
  has_negative_zero(base)
}

#' @export
has_negative_zero.dsct_negation <- function(x) {
  if (typeof(representative(x)) == "integer") {
    return(FALSE)
  }
  has_positive_zero(x[["base"]])
}

