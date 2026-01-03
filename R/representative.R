#' Get a representative value in a discrete set
#'
#' @param x A discretes object.
#' @returns A single numeric vector with a representative value from the
#'   discrete set.
#' @examples
#' representative(integers())
#' representative(natural1() + 7)
#' @export
representative <- function(x) UseMethod("representative")
