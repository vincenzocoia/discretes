#' Natural Numbers
#'
#' Creates an infinite vector of natural numbers starting at 0 or 1.
#' @returns An object of class `discretes`, which is like an infinite-length
#' vector.
#' @rdname natural
#' @export
natural1 <- function() {
  integers(from = 1)
}

#' @rdname natural
#' @export
natural0 <- function() {
  integers(from = 0)
}
