#' Summary group generic for numeric series
#'
#' Support for `min()`, `max()`, `range()`, `sum()`, and `prod()` on numeric
#' series. `min()`, `max()`, and `range()` report the smallest and largest
#' values that bound the series: the extreme discrete values, together with any
#' [sinks()] (limit points) the discrete values approach. `sum()` and `prod()`
#' are only defined for series with finitely many discrete values.
#'
#' @param x,... Numeric series and/or numeric vectors to summarise.
#' @param na.rm Single logical; passed to the underlying summary function when
#'   combining values.
#' @details
#' `min()` and `max()` return the infimum and supremum of the discrete values.
#' For an unbounded series these are `-Inf` and `Inf`; for a series whose values
#' pile up against a finite sink (e.g. `1 / natural1()` approaching `0`), the
#' sink is the relevant bound even though it is not itself a discrete value.
#'
#' `all()` and `any()` are not defined for numeric series, and `sum()` and
#' `prod()` throw an error when the series has infinitely many discrete values.
#' @returns A numeric vector: length 2 for `range()`, length 1 otherwise.
#' @examples
#' range(natural1())          # 1 Inf
#' min(integers(5, 10))       # 5
#' max(1 / natural1())        # 1
#' range(1 / natural1())      # 0 1  (sink at 0 bounds the series below)
#' sum(integers(1, 100))      # 5050
#' @export
Summary.discretes <- function(x, ..., na.rm = FALSE) {
  op <- .Generic # nolint
  args <- list(x, ...)

  if (op %in% c("all", "any")) {
    stop(
      sprintf(
        "`%s()` is not defined for a numeric series.",
        op
      ),
      call. = FALSE
    )
  }

  if (op %in% c("sum", "prod")) {
    vals <- lapply(args, function(a) {
      if (!inherits(a, "discretes")) {
        return(as.numeric(a))
      }
      if (!is.finite(num_discretes(a))) {
        stop(
          "`",
          op,
          "()` is not defined for a series with infinitely many ",
          "discrete values.",
          call. = FALSE
        )
      }
      get_discretes_in(a)
    })
    vals <- unlist(vals)
    return(switch(
      op,
      sum = sum(vals, na.rm = na.rm),
      prod = prod(vals, na.rm = na.rm)
    ))
  }

  # min, max, range: bound by the extreme discrete values and any sinks.
  low <- numeric(0)
  high <- numeric(0)
  for (a in args) {
    if (inherits(a, "discretes")) {
      sink_locs <- sinks(a)[, "location"]
      lo <- next_discrete(a, from = -Inf, n = 1L, include_from = TRUE)
      hi <- prev_discrete(a, from = Inf, n = 1L, include_from = TRUE)
      low <- c(low, lo, sink_locs)
      high <- c(high, hi, sink_locs)
    } else {
      a <- as.numeric(a)
      low <- c(low, a)
      high <- c(high, a)
    }
  }

  switch(
    op,
    min = min(low, na.rm = na.rm),
    max = max(high, na.rm = na.rm),
    range = c(min(low, na.rm = na.rm), max(high, na.rm = na.rm))
  )
}
