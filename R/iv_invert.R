#' @rdname linear_transform
#' @export
iv_invert <- function(x) {
  structure(list(base = x), class = "inverse_infvct")
}
