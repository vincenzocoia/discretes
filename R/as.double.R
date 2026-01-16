#' Discrete values within an interval
#'
#' Return all discrete points for `x` that lie between `from` and `to`.
#' The result is a plain numeric vector so it can be consumed directly by
#' routines that expect finite sequences.
#'
#' @inheritParams num_discretes
#' @return A numeric vector containing all discrete values between `from` and
#'   `to`. Returns `numeric(0)` when the interval contains no discrete support
#'   points.
#' @examples
#' as.numeric(integers(), from = 6.6, to = 10.1)
#' as.numeric(1 / integers(1, 4))
#' @exportS3Method base::as.double
as.double.discretes <- function(x,
                                ...,
                                from = -Inf,
                                to = Inf,
                                include_from = TRUE,
                                include_to = TRUE,
                                tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discretes(x))
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
