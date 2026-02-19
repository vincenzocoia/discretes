#' Raise a discrete set to a power.
#'
#' Apply a power transformation to a discrete set `x` for a given `power`;
#' that is, `x^power`.
#' Internal; use `^` operator instead.
#' 
#' @inheritParams next_discrete
#' @param power The power to raise the series to; numeric of length 0 or 1.
#'   If `x` contains negative values, then only odd values are allowed;
#'   an error is thrown otherwise.
#' @returns A discretes object where the members are the result of applying the
#'  power transformation `^` to `x` with the specified `power`.
#' @examples
#' ## These are the same
#' discretes:::dsct_power(natural0(), power = 2)
#' natural0()^2
#' 
#' ## These are also the same
#' discretes:::dsct_power(integers(), power = 3)
#' integers()^3
dsct_power <- function(x, power) {
  checkmate::assert_true(is_discrete_set(x))
  checkmate::assert_numeric(power, any.missing = FALSE, finite = FALSE)
  if (length(power) > 1) {
    stop("Cannot exponentiate a series by a vector of length >1.")
  }
  if (num_discretes(x) == 0 || length(power) == 0) {
    return(empty_set(typeof(representative(x)^power)))
  }
  old_type <- typeof(representative(x))
  new_type <- typeof(representative(x)^power)
  if (power == 1 && old_type == new_type && !has_negative_zero(x)) {
    # Note: (-0)^1 = +0, which is why we need the negative zero check here.
    return(x)
  }
  if (power == 0) {
    return(as_discretes(1))
  }
  if (power < 0) {
    return(dsct_invert(x^abs(power)))
  }
  nneg <- num_discretes(
    x,
    from = -Inf,
    to = 0,
    include_from = TRUE,
    include_to = FALSE
  )
  if (nneg == 0) {
    return(
      dsct_transform(
        x,
        fun = function(t) t^power,
        inv = function(t) t^(1 / power),
        domain = c(0, Inf),
        range = c(0, Inf)
      )
    )
  }
  if (power %% 2L != 1) {
    stop(
      "Exponentiation of a discretes series is only supported for odd powers ",
      "when the series contains negative values."
    )
  }
  dsct_transform(
    x,
    fun = function(t) t^power,
    inv = function(t) {
      sign(t) * abs(t)^(1 / power)
    }
  )
}