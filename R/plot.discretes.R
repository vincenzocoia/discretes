#' Plot Discrete Values
#'
#' Plot the discrete values represented by a `discretes` object within a
#' specified interval.
#' @param x Object of class `discretes`.
#' @param ... Additional arguments passed to the underlying `plot()` function.
#' @param from,to Numeric values defining the range to plot; single numerics.
#' @param closeness Numeric value indicating how close to the (non-infinite)
#'   sinks points should no longer be plotted. This is because there are an
#'   infinite number of points around each sink.
#' @param tol Numerical tolerance used for snapping `from` or `to` values,
#'   including in internal calls; single non-negative numeric.
#' @returns Invisibly returns the input `x` object after printing a plot
#'   in Base R.
#' @details
#' Sinks at finite values are indicated by vertical dotted gray lines.
#' A red tick mark is used to indicate that a finite sink value is part of
#' the series.
#' When the series extends to infinity in either direction, three arrows
#' (`<` or `>`) are drawn to indicate this.
#'
#' This is a simple plotting scheme with naive handling of infinite discrete
#' values:
#'
#' - The `closeness` parameter does not adjust with the scale of the data, so
#'   may require tuning more often by the user.
#' - When the series extends to infinity (in either direction), an arbitrary
#'   cutoff of 10 units beyond the last finite sink or `representative()`
#'   value (whichever is closer to the infinite sink) is used. This can be
#'   manually adjusted by changing the `from` and `to` parameters.
#' @exportS3Method base::plot
plot.discretes <- function(x,
                           ...,
                           from = -Inf,
                           to = Inf,
                           closeness = 1e-2,
                           tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  checkmate::assert_number(to, lower = from)
  original_sinks <- sinks(x)
  if (-Inf %in% original_sinks[, "location"]) {
    to_neg_inf <- TRUE
  } else {
    to_neg_inf <- FALSE
  }
  if (Inf %in% original_sinks[, "location"]) {
    to_pos_inf <- TRUE
  } else {
    to_pos_inf <- FALSE
  }
  y <- dsct_keep(
    x,
    from = from,
    to = to,
    include_from = TRUE,
    include_to = TRUE
  )
  n <- num_discretes(y)
  if (is.finite(n)) {
    xcollect <- as.numeric(y)
    plot_finite_discretes(
      xcollect,
      to_neg_inf = to_neg_inf,
      to_pos_inf = to_pos_inf,
      ...
    )
    return(invisible(x))
  }
  sinksmat <- sinks(y)
  sinksloc <- sinksmat[, "location"]
  sinksfin <- sinksloc[is.finite(sinksloc)]
  repr <- representative(y)
  if (min(sinksloc) == -Inf) {
    # firstfin <- if (length(sinksfin), min(sinksfin), repr)
    firstfin <- min(repr, sinksfin)
    left_bound <- firstfin - 10
  } else {
    left_bound <- from
  }
  if (max(sinksloc) == Inf) {
    # lastfin <- if (length(sinksfin), max(sinksfin), repr)
    lastfin <- max(repr, sinksfin)
    right_bound <- lastfin + 10
  } else {
    right_bound <- to
  }
  cuts <- sort(c(left_bound, sinksfin, right_bound))
  xcollect <- numeric()
  for (i in seq_along(cuts[-1])) {
    l <- cuts[i]
    r <- cuts[i + 1]
    ldir <- sinksmat[sinksmat[, "location"] == l, "direction"]
    rdir <- sinksmat[sinksmat[, "location"] == r, "direction"]
    if (1 %in% ldir) {
      l <- l + closeness
    }
    if (-1 %in% rdir) {
      r <- r - closeness
    }
    this_x <- as.numeric(y, from = l, to = r)
    xcollect <- append(xcollect, this_x)
  }
  plot_finite_discretes(
    xcollect,
    sinks = sinksloc,
    to_neg_inf = to_neg_inf,
    to_pos_inf = to_pos_inf,
    ...
  )
  return(invisible(x))
}

plot_finite_discretes <- function(x,
                                  sinks = numeric(),
                                  to_neg_inf = FALSE,
                                  to_pos_inf = FALSE,
                                  ...) {
  r <- diff(range(x))
  delta <- 0.02 * r
  xlim1 <- min(x)
  xlim2 <- max(x)
  if (to_neg_inf) {
    xlim1 <- xlim1 - 3 * delta
  }
  if (to_pos_inf) {
    xlim2 <- xlim2 + 3 * delta
  }
  plot(
    x,
    rep(1, length(x)),
    ylim = c(0, 2),
    xlim = c(xlim1, xlim2),
    yaxt = "n",
    ylab = "",
    xlab = "Value",
    main = "Discrete Series",
    pch = "|",
    ...
  )
  abline(v = sinks, col = "gray", lty = 2)
  xsinks <- sinks[sinks %in% x]
  points(xsinks, rep(1, length(xsinks)), pch = "|", col = "red", cex = 1.5)
  if (to_neg_inf) {
    points(min(x) - 1:3 * delta, c(1, 1, 1), pch = "<", col = "gray", cex = 1)
  }
  if (to_pos_inf) {
    points(max(x) + 1:3 * delta, c(1, 1, 1), pch = ">", col = "gray", cex = 1)
  }
}
