#' @export
representative.dsct_union <- function(x) {
  inputs <- x[["inputs"]]
  representatives <- lapply(inputs, representative)
  representatives <- unlist(representatives, use.names = FALSE)
  sort(representatives)[ceiling(length(representatives) / 2)]
}
