#' Create an empty discrete set
#' 
#' Create a discrete set with no members.
#' 
#' @param mode Character vector of length 1 indicating the numeric type of the
#'   discrete set; either "double" (the default) or "integer".
#' @returns An empty discrete set of the specified mode.
#' @examples
#' dsct_empty()
#' @export
dsct_empty <- function(mode = c("double", "integer")) {
  mode <- rlang::arg_match(mode)
  dsct_numeric(vector(length = 0L, mode = mode))
}