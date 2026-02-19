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
  if (from == to) {
    return(
      as.integer(
        include_from && include_to && has_discretes(x, values = from, tol = tol)
      )
    )
  }
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
    FUN.VALUE = numeric(1L)
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
  n <- 0L
  if (include_from) {
    has_from <- vapply(
      inputs,
      function(d) {
        has_discretes(d, values = from, tol = tol)
      },
      FUN.VALUE = logical(1L)
    )
    n <- n + as.integer(any(has_from))
  }
  if (include_to && to > from) {
    has_to <- vapply(
      inputs,
      function(d) {
        has_discretes(d, values = to, tol = tol)
      },
      FUN.VALUE = logical(1L)
    )
    n <- n + as.integer(any(has_to))
  }
  this_from <- from
  next_vals <- 0 # dummy value
  while (length(next_vals) && this_from < to) {
    next_vals <- lapply(
      inputs,
      function(d) {
        next_discrete(d, from = this_from, include_from = FALSE, tol = tol)
      }
    )
    next_vals <- unlist(next_vals, use.names = FALSE)
    next_vals <- next_vals[next_vals < to]
    n <- n + as.integer(length(next_vals) > 0)
    this_from <- min(next_vals, Inf) # Inf in case there are no next_vals
  }
  n
}
