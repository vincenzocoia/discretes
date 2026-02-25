#' @export
num_discretes.dsct_inverse <- function(x,
                                       from = -Inf,
                                       to = Inf,
                                       ...,
                                       include_from = TRUE,
                                       include_to = TRUE,
                                       tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (from == to) {
    return(
      as_integerish(
        include_from && include_to && has_discretes(x, values = from, tol = tol)
      )
    )
  }
  n <- 0L
  if (from == -Inf && include_from) {
    n <- n + has_discretes(x, values = -Inf)
    include_from <- FALSE
  }
  if (to == Inf && include_to) {
    n <- n + has_discretes(x, values = Inf)
    include_to <- FALSE
  }
  if (from == 0 && include_from) {
    n <- n + has_discretes(x, values = 0)
    include_from <- FALSE
  }
  if (to == 0 && include_to) {
    n <- n + has_discretes(x, values = 0)
    include_to <- FALSE
  }
  
  base <- x$base
  if (sign(to) < 1) {
    # Interval doesn't reach positive values.
    n <- n + num_discretes(
      base,
      from = 1 / (-abs(to)),  # In case to == 0, ensures to == -0.
      to = 1 / from,
      include_from = include_to,
      include_to = include_from,
      tol = tol,
      ...
    )
    return(n)
  }
  
  if (sign(from) > -1) {
    # Interval doesn't reach negative values.
    n <- n + num_discretes(
      base,
      from = 1 / to,
      to = 1 / abs(from),  # In case from == 0, ensures from == +0.
      include_from = include_to,
      include_to = include_from,
      tol = tol,
      ...
    )
    return(n)
  }
  
  # Count the straddled 0, if present.
  n <- n + any(has_discretes(base, values = c(-Inf, Inf)))
  
  n_neg <- num_discretes(
    base,
    from = -Inf,
    to = 1 / from,
    include_from = FALSE,
    include_to = include_from,
    tol = tol,
    ...
  )
  
  n_pos <- num_discretes(
    base,
    from = 1 / to,
    to = Inf,
    include_from = include_to,
    include_to = FALSE,
    tol = tol,
    ...
  )
  
  n + n_neg + n_pos
}