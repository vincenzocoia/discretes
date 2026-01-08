#' @noRd
#' @export
num_discretes.dsct_union <- function(x,
                                     ...,
                                     from = -Inf,
                                     to = Inf,
                                     include_from = TRUE,
                                     include_to = TRUE,
                                     tol = sqrt(.Machine$double.eps)) {
  ellipsis::check_dots_empty()
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  inputs <- x$inputs
  counts <- vapply(
    inputs,
    function(comp) {
      num_discretes(
        comp,
        from = from,
        to = to,
        include_from = include_from,
        include_to = include_to,
        tol = tol
      )
    },
    numeric(1L)
  )
  if (any(is.na(counts))) {
    return(NA_integer_)
  }
  if (any(is.infinite(counts))) {
    return(Inf)
  }
  if (all(counts == 0L)) {
    return(0L)
  }
  values <- unlist(
    lapply(seq_along(inputs), function(i) {
      if (!counts[[i]]) {
        return(numeric(0))
      }
      discretes_between(
        inputs[[i]],
        from = from,
        to = to,
        include_from = include_from,
        include_to = include_to,
        tol = tol
      )
    }),
    use.names = FALSE
  )
  length(unique(values))
}
