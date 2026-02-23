#' Extract members of a discrete set
#' 
#' Extract a finite subset of values from a discrete set by asking for
#' specific values (`get_discretes_at()`) or by setting a range
#' (`get_discretes_in()`). For `get_discretes_at()`, specified values "snap" to
#' those in the discrete set if they are within `tol` of a value, and are
#' dropped otherwise; `NA` values are kept in place.
#' 
#' @inheritParams num_discretes
#' @returns 
#' A numeric vector containing all discrete values in the provided series `x`:
#' 
#' - For `get_discretes_in()`, all discrete values between `from` and `to`,
#'     ordered from smallest to largest.
#' - For `get_discretes_at()`, all discrete values that snap to `values`.
#' 
#' An error will be thrown in `get_discretes_in()` if there are infinitely
#' many points in the range.
#' @examples
#' get_discretes_in(integers(), from = 6.6, to = 10.1)
#' get_discretes_in(1 / arithmetic(1, 4, n_left = 3, n_right = 5))
#' get_discretes_at(integers(), values = c(-10, 4, 3.5, 10, NA))
#' get_discretes_at(integers(), values = 5.5)
#' @seealso [as.double.discretes()]
#' @rdname get_discretes
#' @export
get_discretes_in <- function(x,
                             ...,
                             from = -Inf,
                             to = Inf,
                             include_from = TRUE,
                             include_to = TRUE,
                             tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discrete_set(x))
  ellipsis::check_dots_empty()
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_logical(include_to, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)

  n <- num_discretes(
    x,
    from = from,
    to = to,
    include_from = include_from,
    include_to = include_to,
    tol = tol
  )

  if (is.infinite(n)) {
    stop(
      "Infinitely many values lie in the requested interval; ",
      "cannot return a vector."
    )
  }

  next_discrete(
    x,
    from = from,
    n = n,
    include_from = include_from,
    tol = tol
  )
}
