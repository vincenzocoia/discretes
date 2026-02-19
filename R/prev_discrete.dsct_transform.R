#' @export
prev_discrete.dsct_transform <- function(x,
                                         from,
                                         ...,
                                         n = 1L,
                                         include_from = TRUE,
                                         tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  if (n == 0) {
    return(vector(mode = typeof(representative(x)), length = 0L))
  }
  rng <- x[["range"]]
  dom <- x[["domain"]]
  if (from > rng[2]) {
    base_from <- dom[2]
    include_from <- TRUE
  } else if (from < rng[1]) {
    return(vector(mode = typeof(representative(x)), length = 0L))
  } else {
    base_from <- x[["inv"]](from)
  }
  base_prev <- prev_discrete(
    x[["base"]],
    from = base_from,
    n = n,
    include_from = include_from,
    tol = tol,
    ...
  )
  res <- x[["fun"]](base_prev)
  if (any(res < rng[1] | res > rng[2], na.rm = TRUE)) {
    warning(
      "Returning values outside of the specified range ",
      "of the transformation function. Has the `range` argument been ",
      "specified properly in `dsct_transform()`?"
    )
  }
  res
}
