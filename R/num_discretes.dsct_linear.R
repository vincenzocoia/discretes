#' @noRd
#' @export
num_discretes.dsct_linear <- function(x,
                                      ...,
                                      from = -Inf,
                                      to = Inf,
                                      include_from = TRUE,
                                      include_to = TRUE) {
  checkmate::assert_number(from)
  checkmate::assert_number(to)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  base_from <- (from - x$b) / x$m
  base_to <- (to - x$b) / x$m
  num_discretes(
    x$base,
    from = base_from,
    to = base_to,
    include_from = include_from,
    include_to = include_to,
    ...
  )
}
