#' Create an empty numeric series
#'
#' Create a numeric series with no discrete values.
#'
#' @param mode Character vector of length 1 indicating the numeric type of the
#'   numeric series; either "double" (the default) or "integer".
#' @returns An empty numeric series of the specified mode.
#' @examples
#' empty_series()
#' @export
empty_series <- function(mode = c("double", "integer")) {
  mode <- rlang::arg_match(mode)
  as_discretes(vector(length = 0L, mode = mode))
}