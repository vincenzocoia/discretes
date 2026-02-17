#' Linearly Transform a Discrete Value Series
#' 
#' Apply a linear function to a discrete value series (`m * x + b`).
#' Internal function, with preference to use `+`, `-`, `*`, and `/` instead.
#' 
#' @inheritParams next_discrete
#' @param m A numeric value indicating the multiplier.
#' @param b A numeric value indicating the intercept. Allowed to be `NULL`
#'   (the default) to indicate the transformation `m * x` without an intercept,
#'   which is important to distinguish signed zero.
#' @returns A linearly transformed discretes object.
#' @examples
#' discretes:::dsct_linear(integers(), m = 2)
#' discretes:::dsct_linear(integers(), m = 2, b = 0.5)
dsct_linear <- function(x, m, b = NULL) {
  UseMethod("dsct_linear")
}

#' @export
dsct_linear.discretes <- function(x, m, b = NULL) {
  checkmate::assert_numeric(m, any.missing = FALSE)
  checkmate::assert_numeric(b, any.missing = FALSE, null.ok = TRUE)
  if (length(m) > 1) {
    stop("Cannot multiply a series by a vector of length >1.")
  }
  if (m < 0) {
    return(dsct_linear(dsct_negate(x), m = abs(m), b = b))
  }
  if (!is.null(b)) {
    if (length(b) > 1) {
      stop("Cannot add a vector of length >1 to a series.")
    }
    bb <- b
  } else {
    bb <- 0L # To use when signed zero doesn't matter.
  }
  if (num_discretes(x) == 0 || length(m) == 0 || length(bb) == 0) {
    return(dsct_empty(typeof(m * representative(x) + bb)))
  }
  n_neg <- num_discretes(
    x,
    from = -Inf,
    to = 0,
    include_from = FALSE,
    include_to = FALSE
  )
  n_pos <- num_discretes(
    x,
    from = 0,
    to = Inf,
    include_from = FALSE,
    include_to = FALSE
  )
  symbolic_x <- c(
    pluck_discretes(x, values = c(-Inf, Inf)),
    zeroes_vector(x),
    (-1)[n_neg > 0],
    (1)[n_pos > 0]
  )
  if (is.null(b)) {
    symbolic_y <- m * symbolic_x
  } else {
    symbolic_y <- m * symbolic_x + b
  }
  if (any(is.na(symbolic_y))) {
    # Can arise from -Inf + Inf or 0 * Inf, for example.
    stop("NA or NaN values arise from the supplied linear transformation.")
  }
  if (is.infinite(bb) || is.infinite(m) || m == 0) {
    # The linear function is flat in these cases, with one or two plateaus,
    # with behaviour completely described by x = c(-Inf, -1, -0, 0, 1, Inf),
    # of which "symbolic_x" is a subset.
    return(dsct_numeric(symbolic_y))
  }
  if (is.null(b)) {
    fun <- function(t) m * t
    inv <- function(t) t / m
  } else {
    fun <- function(t) m * t + b
    inv <- function(t) (t - b) / m
  }
  sinkmat <- sinks(x)
  sinkmat[, "location"] <- fun(sinkmat[, "location"])
  new_dsct_transform(
    data = list(
      base = x,
      fun = fun,
      inv = inv,
      domain = c(-Inf, Inf),
      range = c(-Inf, Inf),
      m = m,
      b = b
    ),
    name = "Linear-transformed",
    sinks = sinkmat,
    subclass = "dsct_linear"
  )
}
