#' @export
iv_negate.infvctr <- function(x) {
  new_infvctr(list(base = x), subclass = "negate_infvctr")
}
