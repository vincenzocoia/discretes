#' Sinks
#' 
#' Sinks are limit points in a discrete set. That means that discrete values
#' get arbitrarily close to the sink (from the left or right), and that there
#' are infinitely many discrete points around the sink.
#' 
#' @inheritParams num_discretes
#' @returns A matrix with two columns: `location` and `direction`. Each row
#'  corresponds to a sink, where `location` is the location of the sink
#'  (possibly infinite), and `direction` indicates whether the sink is
#'  approached from the left (-1) or right (1).
#' @examples
#' # The set of integers have sinks at +Inf and -Inf
#' sinks(integers())
#' has_sink(integers())
#' 
#' # The set 1, 1/2, 1/4, 1/8, ... has a sink at 0 approached from the right.
#' halves <- 0.5^natural0()
#' sinks(halves)
#' has_sink(halves, to = 0)
#' has_sink(halves, from = 0)
#' 
#' # The reciprocal of the integers has a sink at 0 approached from both the
#' # left and right; while the integer 0 gets mapped to Inf, infinity is not a
#' # sink because discrete values don't get arbitrarily close to it.
#' reciprocals <- 1 / integers()
#' sinks(reciprocals)
#' has_discretes(reciprocals, Inf) # Yet Inf is a member.
#' @rdname sinks
#' @export
sinks <- function(x) {
  if (is.numeric(x)) {
    return(sinks_matrix())
  }
  attr(x, "sinks")
}

#' @rdname sinks
#' @export
has_sink <- function(x,
                     from = -Inf,
                     to = Inf,
                     ...,
                     tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discrete_set(x))
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  n <- num_discretes(x, from = from, to = to, tol = tol)
  n == Inf
}
