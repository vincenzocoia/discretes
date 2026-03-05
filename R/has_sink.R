#' Test for sinks in a numeric series
#'
#' `has_sink_in()` tests whether a numeric series has a sink in the interval
#' `[from, to]`. `has_sink_at()` tests whether there is a sink at a
#' given value, optionally with a specific direction.
#'
#' @inheritParams num_discretes
#' @param value Single numeric to check for the existence of a sink.
#' @param dir Single character: direction of the sink. `"either"` (default)
#'   ignores direction; `"left"` or `"right"` require the sink to be
#'   approached from that side; `"both"` requires it to be approached from
#'   both sides.
#' @returns A length-one logical: `TRUE` if a sink exists in the range
#'   (`has_sink_in`) or at `value` with the given `dir`
#'   (`has_sink_at`); `FALSE` otherwise.
#' @seealso See [sinks()] to get all sinks, and a description of sinks.
#' @examples
#' # The set of integers have sinks at +Inf and -Inf
#' has_sink_in(integers())
#' has_sink_at(integers(), Inf)
#' has_sink_at(integers(), -Inf, dir = "right")
#'
#' # The set 1, 1/2, 1/4, 1/8, ... has a sink at 0 approached from the right.
#' halves <- 0.5^natural0()
#' has_sink_in(halves, to = 0)
#' has_sink_at(halves, 0, dir = "right")
#'
#' # Reciprocal of integers: sink at 0 from both sides
#' reciprocals <- 1 / integers()
#' has_sink_at(reciprocals, 0, dir = "both")
#' @rdname has_sink
#' @export
has_sink_in <- function(x, from = -Inf, to = Inf) {
  checkmate::assert_true(is_series(x))
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  y <- dsct_keep(x, from = from, to = to)
  nrow(sinks(y)) > 0
}


#' @rdname has_sink
#' @export
has_sink_at <- function(x, value, dir = c("either", "left", "right", "both")) {
  checkmate::assert_true(is_series(x))
  checkmate::assert_number(value)
  dir <- rlang::arg_match(dir)
  mat <- sinks(x)
  all_locs <- mat[, "location"]
  if (!value %in% all_locs) {
    return(FALSE)
  }
  if (dir == "either") {
    return(TRUE)
  }
  all_dirs <- mat[, "direction"]
  dirs <- all_dirs[all_locs == value]
  if (dir == "left") {
    return(-1 %in% dirs)
  }
  if (dir == "right") {
    return(1 %in% dirs)
  }
  return(-1 %in% dirs && 1 %in% dirs)
}
