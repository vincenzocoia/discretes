#' @noRd
#' @export
representative.dsct_union <- function(x) {
  inputs <- x$inputs
  is_integer <- vapply(
    inputs,
    function(d) {
      is.integer(representative(d))
    },
    FUN.VALUE = logical(1L)
  )
  if (all(is_integer)) {
    type <- "integer"
  } else {
    type <- "numeric"
  }
  representatives <- lapply(inputs, representative)
  representatives <- unlist(representatives, use.names = FALSE)
  sort(representatives)[ceiling(length(representatives) / 2)]
}
