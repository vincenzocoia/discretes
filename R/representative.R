#' Get a representative discrete value in a numeric series
#'
#' @inheritParams next_discrete
#' @returns A single numeric: a representative discrete value from the
#'   numeric series, with the proper mode.
#' @examples
#' representative(integers())
#' representative(natural1() + 7)
#' @export
representative <- function(x) UseMethod("representative")
