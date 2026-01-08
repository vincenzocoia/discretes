#' @noRd
#' @export
prev_discrete.dsct_union <- function(x,
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
      prev_discrete(
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
    prev_val <- max(candidate_values)
    sinks <- vapply(
      inputs,
      function(d) {
        sink_is_between(d, from = prev_val, to = current_from, tol = tol)
      },
      FUN.VALUE = logical(1L)
    )
    if (any(sinks)) {
      return(result)
    }
    result <- append(result, prev_val)
    current_from <- prev_val
  }
  result
}
