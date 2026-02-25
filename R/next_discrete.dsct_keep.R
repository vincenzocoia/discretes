#' @export
next_discrete.dsct_keep <- function(x,
                                    from,
                                    ...,
                                    n = 1L,
                                    include_from = FALSE,
                                    tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  base <- x[["base"]]
  left <- x[["left"]]
  right <- x[["right"]]
  include_left <- x[["include_left"]]
  include_right <- x[["include_right"]]
  is_downstream <- is_between(
    from,
    lower = right,
    upper = Inf,
    include_lower = !include_right,
    include_upper = TRUE
  )
  if (is_downstream) {
    return(vector(typeof(representative(base)), length = 0L))
  }
  is_upstream <- is_between(
    from,
    lower = -Inf,
    upper = left,
    include_lower = TRUE,
    include_upper = !include_left
  )
  if (is_upstream) {
    from <- left
    include_from <- include_left
  }
  n_available <- num_discretes(
    base,
    from = from,
    to = right,
    include_from = include_from,
    include_to = include_right,
    tol = tol
  )
  n <- min(n_available, n)
  next_discrete(
    base,
    from = from,
    n = n,
    include_from = include_from,
    tol = tol,
    ...
  )
}
