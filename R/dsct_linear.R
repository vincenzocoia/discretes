#' Linearly Transform a Discrete Value Series
#' 
#' Apply a linear function to a discrete value series (`m * x + b`).
#' Internal function, with preference to use `+`, `-`, `*`, and `/` instead.
#' 
#' @inheritParams dsct_negate
#' @param m A numeric value indicating the multiplier.
#' @param b A numeric value indicating the intercept. Allowed to be missing
#'   (as opposed to setting equal to zero), to preserve signed zeroes.
#' @returns A linearly transformed discretes object.
#' @examples
#' discretes:::dsct_linear(integers(), m = 2)
#' discretes:::dsct_linear(integers(), m = 2, b = 0.5)
dsct_linear <- function(x, m, b) {
  UseMethod("dsct_linear")
}

#' @export
dsct_linear.discretes <- function(x, m, b) {
  checkmate::assert_numeric(m, any.missing = FALSE)
  if (length(m) > 1) {
    stop("Cannot multiply a series by a vector of length >1.")
  }
  old_type <- typeof(representative(x))
  if (!missing(b)) {
    checkmate::assert_numeric(b, any.missing = FALSE)
    if (length(b) > 1) {
      stop("Cannot add a vector of length >1 to a series.")
    }
    new_type <- typeof(m * representative(x) + b)
    bb <- b
    l <- list(base = x, m = m, b = b)
  } else {
    new_type <- typeof(m * representative(x))
    bb <- 0L # When signed zero doesn't matter.
    l <- list(base = x, m = m)
  }
  if (num_discretes(x) == 0 || length(m) == 0 || length(bb) == 0) {
    return(dsct_empty(typeof(m * representative(x) + bb)))
  }
  if (m < 0) {
    return(dsct_linear(dsct_negate(x), m = abs(m), b = b))
  }
  if (m == 1 && (missing(b) || has_negative_zero(b)) && new_type == old_type) {
    return(x)
  }
  if ((m == -Inf && bb == Inf) || (m == Inf && bb == -Inf)) {
    stop("Invalid linear transformation: ", m, " * x + ", bb, ": NaN.")
  }
  if (m == 0 && any(test_discrete(x, values = c(-Inf, Inf)))) {
    stop("Cannot multiply a series containing infinity by 0: NaN.")
  }
  if (is.infinite(m) && test_discrete(x, values = 0)) {
    stop("Cannot multiply a series containing 0 by infinity: NaN.")
  }
  if (is.infinite(bb) && test_discrete(x, values = -bb)) {
    stop("Cannot add ", bb, " to a series containing ", -bb, ": NaN.")
  }
  if (is.infinite(bb)) {
    return(dsct_numeric(bb))
  }
  if (is.infinite(m)) {
    has_pos <- num_discretes(x, from = 0, to = Inf, include_from = FALSE) > 0
    has_neg <- num_discretes(x, from = -Inf, to = 0, include_to = FALSE) > 0
    v <- c(Inf, -Inf)[c(has_pos, has_neg)]
    return(dsct_numeric(m * v))
  }
  if (m == 0) {
    has_pos <- has_positive_zero(x) ||
      (num_discretes(x, from = 0, to = Inf, include_from = FALSE) > 0)
    has_neg <- has_negative_zero(x) ||
      (num_discretes(x, from = -Inf, to = 0, include_to = FALSE) > 0)
    v <- c(0, -0)[c(has_pos, has_neg)]
    if (missing(b)) {
      v <- m * v
    } else {
      v <- m * v + b
    }
    return(dsct_numeric(v))
  }
  sinksmat <- sinks(x)
  sinksmat[, "location"] <- sinksmat[, "location"] * m + bb
  new_discretes(
    data = l,
    name = "Linear-transformed",
    sinks = sinksmat,
    subclass = "dsct_linear"
  )
}
