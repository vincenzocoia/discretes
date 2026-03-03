#' Exponentiation of a discrete set
#' 
#' Exponentiate a discrete set `x` with a given base; that is, `base^x`.
#' `dsct_exp()` is a special case of `dsct_raise()` where the base is `exp(1)`.
#' Internal; use `exp()` or `^` operators instead.
#' 
#' @inheritParams next_discrete
#' @param base The base to use for exponentiation; numeric of length 0 or 1,
#'   with negative values not allowed (an error is thrown otherwise).
#' @returns A discretes object where each member is the result of 
#'   exponentiating a member of `x` by `base` (that is, `base^x`).
#' @examples
#' # These are the same
#' discretes:::dsct_exp(integers())
#' discretes:::dsct_raise(integers(), base = exp(1))
#' exp(integers())
#' 
#' # These are also the same
#' discretes:::dsct_raise(integers(), base = 2)
#' 2^integers()
#' 
#' # This also works. Notice how the set reduces.
#' 0^integers()
#' @rdname exponentiate
dsct_raise <- function(x, base = exp(1)) {
  checkmate::assert_true(is_discrete_set(x))
  checkmate::assert_numeric(base, any.missing = FALSE, finite = FALSE)
  if (!length(base) || num_discretes(x) == 0) {
    return(empty_series(typeof(representative(x)^base)))
  }
  if (length(base) > 1) {
    stop("Cannot exponentiate a series by a vector of length >1.")
  }
  if (base < 0) {
    stop("Exponentiating a discrete set with a negative base is not supported.")
  }
  if (base == 1) {
    return(as_discretes(1))
  }
  if (base == 0 || base == Inf) {
    has_zero <- has_discretes(x, values = 0)
    has_neg <- num_discretes(
      x,
      from = -Inf,
      to = 0,
      include_from = TRUE,
      include_to = FALSE
    ) > 0
    has_pos <- num_discretes(
      x,
      from = 0,
      to = Inf,
      include_from = FALSE,
      include_to = TRUE
    ) > 0
    if (base == 0) {
      vals <- c(Inf, 1, 0)[c(has_neg, has_zero, has_pos)]
    } else {
      vals <- c(0, 1, Inf)[c(has_neg, has_zero, has_pos)]
    }
    return(as_discretes(vals))
  }
  if (base < 1) {
    # Function is decreasing and therefore cannot be directly put into
    # dsct_transform().
    res <- dsct_transform(
      x,
      fun = function(t) (1 / base)^t,
      inv = function(t) log(t, base = 1 / base),
      range = c(0, Inf)
    )
    return(1 / res)
  }
  dsct_transform(
    x,
    fun = function(t) base^t,
    inv = function(t) log(t, base = base),
    range = c(0, Inf)
  )
}

#' @rdname exponentiate
dsct_exp <- function(x) {
  dsct_transform(
    x,
    fun = exp,
    inv = log,
    range = c(0, Inf)
  )
}