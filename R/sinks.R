#' Sinks
#'
#' Sinks are limit points in a discrete set. That means that discrete values
#' get arbitrarily close to the sink (from the left or right), and that there
#' are infinitely many discrete points around the sink. This function returns
#' a matrix of all sinks in the numeric series.
#'
#' @inheritParams num_discretes
#' @returns A matrix with two columns: `location` and `direction`. Each row
#'   corresponds to a sink, where `location` is the location of the sink
#'   (possibly infinite), and `direction` indicates whether the sink is
#'   approached from the left (-1) or right (1).
#' @seealso [has_sink_in()], [has_sink_at()]
#' @examples
#' # The set of integers have sinks at +Inf and -Inf
#' sinks(integers())
#'
#' # The set 1, 1/2, 1/4, 1/8, ... has a sink at 0 approached from the right.
#' halves <- 0.5^natural0()
#' sinks(halves)
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
