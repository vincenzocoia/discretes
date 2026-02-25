#' @export
num_discretes.dsct_keep <- function(x,
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
  base <- x[["base"]]
  left <- x[["left"]]
  right <- x[["right"]]
  include_left <- x[["include_left"]]
  include_right <- x[["include_right"]]
  out_of_range <- is_between(
    to,
    lower = -Inf,
    upper = left,
    include_lower = TRUE,
    include_upper = !include_left
  ) || is_between(
    from,
    lower = right,
    upper = Inf,
    include_lower = !include_right,
    include_upper = TRUE
  )
  if (out_of_range) {
    return(0L)
  }
  if (from == left) {
    include_from <- include_from && include_left
  }
  if (from < left) {
    from <- left
    include_from <- include_left
  }
  if (to == right) {
    include_to <- include_to && include_right
  }
  if (to > right) {
    to <- right
    include_to <- include_right
  }
  num_discretes(
    base,
    from = from,
    to = to,
    include_from = include_from,
    include_to = include_to,
    tol = tol,
    ...
  )
}
