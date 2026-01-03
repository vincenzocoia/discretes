#' @noRd
#' @export
num_discretes.dsct_negation <- function(x,
                                        ...,
                                        from = -Inf,
                                        to = Inf,
                                        include_from = TRUE,
                                        include_to = TRUE) {
  ellipsis::check_dots_empty()
  checkmate::assert_number(from)
  checkmate::assert_number(to)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  base_from <- -to
  base_to <- -from
  num_discretes(
    x$base,
    from = base_from,
    to = base_to,
    include_from = include_to,
    include_to = include_from
  )
}
