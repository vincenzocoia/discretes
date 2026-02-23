#' Plot Discrete Values
#'
#' Plot the discrete values represented by a `discretes` object within a
#' specified interval.
#' @inheritParams next_discrete
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
#' 
#' When the series extends to infinity in either direction, three arrows
#' (`<` or `>`) are drawn to indicate this. When infinity is part of the series,
#' the last arrow is red.
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
  
  y <- dsct_keep(
    x,
    from = from,
    to = to,
    include_from = TRUE,
    include_to = TRUE
  )
  sinksmat <- sinks(y)
  sinksmatfin <- sinksmat[is.finite(sinksmat[, "location"]), , drop = FALSE]
  sinklocs <- sinksmat[, "location"]
  sinksfin <- sinklocs[is.finite(sinklocs)]
  for (i in seq_len(nrow(sinksmatfin))) {
    l <- sinksmatfin[i, "location"]
    dir <- sinksmatfin[i, "direction"]
    drop_from <- min(l, l + dir * closeness)
    drop_to <- max(l, l + dir * closeness)
    y <- dsct_drop(
      y,
      from = drop_from,
      to = drop_to,
      include_from = FALSE,
      include_to = FALSE,
      tol = tol
    )
  }
  rpr <- representative(y)
  inc_neg_inf <- has_discretes(x, values = -Inf)
  inc_pos_inf <- has_discretes(x, values = Inf)
  if (inc_neg_inf) {
    neg_inf <- "closed"
  } else if (-Inf %in% sinklocs) {
    neg_inf <- "open"
  } else {
    neg_inf <- "no"
  }
  if (inc_pos_inf) {
    pos_inf <- "closed"
  } else if (Inf %in% sinklocs) {
    pos_inf <- "open"
  } else {
    pos_inf <- "no"
  }
  left_bound <- next_discrete(y, from = from, include_from = is.finite(from))
  right_bound <- prev_discrete(y, from = to, include_from = is.finite(to))
  if (!length(left_bound)) {
    firstfin <- min(rpr, sinksfin)
    left_bound <- firstfin - 10
  }
  if (!length(right_bound)) {
    lastfin <- max(rpr, sinksfin)
    right_bound <- lastfin + 10
  }
  xcollect <- get_discretes_in(y, from = left_bound, to = right_bound)
  plot_finite_discretes(
    xcollect,
    sinklocs = sinklocs,
    neg_inf = neg_inf,
    pos_inf = pos_inf,
    ...
  )
  return(invisible(x))
}


#' Helper function for plotting discrete value series
#' 
#' @param x Numeric vector to plot.
#' @param sinklocs Numeric vector of sink locations to indicate on the plot
#'   as dashed gray lines.
#' @param neg_inf,pos_inf Either: `"closed"`, where the infinite point is
#'   included in the discrete value series; `"open"`, where it's a limit point
#'   but not included in the series; or `"no"` (the default) where the series
#'   does not extend to infinity in the specified direction.
#' @param ... Arguments to pass to the main `plot()` function.
#' @returns Plot of the numeric vector on the number line.
#' @noRd
plot_finite_discretes <- function(x,
                                  sinklocs = numeric(),
                                  neg_inf = c("no", "open", "closed"),
                                  pos_inf = c("no", "open", "closed"),
                                  ...) {
  neg_inf <- rlang::arg_match(neg_inf)
  pos_inf <- rlang::arg_match(pos_inf)
  r <- diff(range(x))
  delta <- 0.02 * r
  xlim1 <- min(x)
  xlim2 <- max(x)
  yval <- 0
  if (neg_inf != "no") {
    xlim1 <- xlim1 - 3 * delta
  }
  if (pos_inf != "no") {
    xlim2 <- xlim2 + 3 * delta
  }
  plot(
    x,
    rep(yval, length(x)),
    ylim = c(-1, 1) + yval,
    xlim = c(xlim1, xlim2),
    yaxt = "n",
    bty = "n",
    ylab = "",
    xlab = "Value",
    main = "Discrete Series",
    pch = "|",
    ...
  )
  graphics::abline(h = yval, col = "black")
  graphics::abline(v = sinklocs, col = "gray", lty = 2)
  xsinklocs <- sinklocs[sinklocs %in% x]
  graphics::points(
    xsinklocs,
    rep(yval, length(xsinklocs)),
    pch = "|",
    col = "red",
    cex = 1.5
  )
  if (neg_inf != "no") {
    graphics::points(
      min(x) - 1:3 * delta,
      c(yval, yval, yval),
      pch = "<",
      col = "gray",
      cex = 1
    )
  }
  if (pos_inf != "no") {
    graphics::points(
      max(x) + 1:3 * delta,
      c(yval, yval, yval),
      pch = ">",
      col = "gray",
      cex = 1
    )
  }
  if (neg_inf == "closed") {
    graphics::points(
      min(x) - 3 * delta,
      yval,
      pch = "<",
      col = "red",
      cex = 1,
    )
  }
  if (pos_inf == "closed") {
    graphics::points(
      max(x) + 3 * delta,
      yval,
      pch = ">",
      col = "red",
      cex = 1
    )
  }
}
