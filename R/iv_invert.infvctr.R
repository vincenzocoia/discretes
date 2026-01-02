#' @describeIn linear_transform Default reciprocal transform for infvctrs.
#' @export
iv_invert.infvctr <- function(x) {
  new_infvctr(
    data = list(base = x),
    subclass = "inverse"
  )
}
