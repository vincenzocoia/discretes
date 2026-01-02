# Rationale for swapping the order of negation and inversion is that
# negation is more likely to simplify.
#' @noRd
#' @export
iv_negate.inverse <- function(x) {
  iv_invert(iv_negate(x$base))
}
