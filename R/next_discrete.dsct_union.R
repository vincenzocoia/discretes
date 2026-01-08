#' @noRd
#' @export
next_discrete.dsct_union <- function(x,
                                     from,
                                     ...,
                                     n = 1L,
                                     include_from = TRUE,
                                     tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  ellipsis::check_dots_empty()
  inputs <- x$inputs
  result <- vector(type, length = 0L)
  if (include_from) {
    has_from <- vapply(
      inputs,
      function(d) {
        test_discrete(d, values = from, tol = tol)
      },
      FUN.VALUE = logical(1L)
    )
    if (any(has_from)) {
      result <- from
      mode(result) <- type # in case `from` is not integer but should be
    }
  }
  current_from <- from
  while (length(result) < n) {
    candidates <- lapply(inputs, function(comp) {
      next_discrete(
        comp,
        from = current_from,
        n = 1L,
        include_from = FALSE,
        tol = tol
      )
    })
    candidate_values <- unlist(candidates, use.names = FALSE)
    if (!length(candidate_values)) {
      return(result)
    }
    next_val <- min(candidate_values)
    sinks <- vapply(
      inputs,
      function(d) {
        sink_is_between(d, from = current_from, to = next_val, tol = tol)
      },
      FUN.VALUE = logical(1L)
    )
    if (any(sinks)) {
      return(result)
    }
    result <- append(result, next_val)
    current_from <- next_val
  }
  result
}
