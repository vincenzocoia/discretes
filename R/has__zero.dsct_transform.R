#' @export
has_negative_zero.dsct_transform <- function(x) {
  if (!has_discretes(x, values = 0)) {
    return(FALSE)
  }
  maps_to_0 <- x[["inv"]](0)
  if (maps_to_0 == 0) {
    maps_to_0 <- zeroes_vector(x[["base"]])
  }
  has_negative_zero(x[["fun"]](maps_to_0))
}

#' @export
has_positive_zero.dsct_transform <- function(x) {
  if (!has_discretes(x, values = 0)) {
    return(FALSE)
  }
  maps_to_0 <- x[["inv"]](0)
  if (maps_to_0 == 0) {
    maps_to_0 <- zeroes_vector(x[["base"]])
  }
  has_positive_zero(x[["fun"]](maps_to_0))
}