#' Convert values to integer basis
#'
#' An arithmetic sequence is like a mapping of the integers n_left:n_right --
#' the "basis" -- by scaling and then shifting. This function takes values on
#' the original arithmetic series space and returns it to the basis scale.
#' The result need not be integers.
#' @param x arithmetic series of class `arithmetic_infvctr`
#' @param values Numeric vector of values in the arithmetic series space.
#' @returns Numeric vector of values in the integer basis space.
#' @noRd
arithmetic_basis <- function(x, values) {
  checkmate::assert_class(x, "arithmetic_infvctr")
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  (values - x$representative) / x$spacing
}
