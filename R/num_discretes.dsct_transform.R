#' @export
num_discretes.dsct_transform <- function(x,
                                         ...,
                                         from = -Inf,
                                         to = Inf,
                                         include_from = TRUE,
                                         include_to = TRUE,
                                         tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  inv <- x[["inv"]]
  dom <- x[["domain"]]
  rng <- x[["range"]]
  if (to < rng[1] || from > rng[2]) {
    return(0L)
  }
  if (from < rng[1]) {
    base_from <- dom[1]
    include_from <- TRUE
  } else {
    base_from <- inv(from)
  }
  if (to > rng[2]) {
    base_to <- dom[2]
    include_to <- TRUE
  } else {
    base_to <- inv(to)
  }
  num_discretes(
    x[["base"]],
    from = base_from,
    to = base_to,
    include_from = include_from,
    include_to = include_to,
    tol = tol,
    ...
  )
}
