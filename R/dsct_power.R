#' Raise a numeric series to a power
#'
#' Apply a power transformation to a numeric series `x` for a given `power`;
#' that is, `x^power`.
#' Internal; use `^` operator instead.
#'
#' @inheritParams next_discrete
#' @param power The power to raise the series to; numeric of length 0 or 1.
#'   If `x` contains negative discrete values, then `power` must be an integer,
#'   otherwise an error is thrown because the result would contain complex
#'   numbers, which are not supported.
#' @returns A numeric series whose discrete values are the result of applying
#'   the power transformation `^` to the discrete values of `x` with the
#'   specified `power`.
#' @examples
#' ## These are the same
#' discretes:::dsct_power(natural0(), power = 2)
#' natural0()^2
#' 
#' ## These are also the same
#' discretes:::dsct_power(integers(), power = 3)
#' integers()^3
dsct_power <- function(x, power) {
  checkmate::assert_true(is_series(x))
  checkmate::assert_numeric(power, any.missing = FALSE, finite = FALSE)
  if (length(power) > 1) {
    stop("Cannot exponentiate a series by a vector of length >1.")
  }
  if (num_discretes(x) == 0 || length(power) == 0) {
    return(empty_series(typeof(representative(x)^power)))
  }
  old_type <- typeof_dsct(x)
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
  # - For x >= 0, x^power is always monotonic.
  # - For x < 0, x^power is complex unless `power` is integer:
  #   - Odd integers (..., -3, -1, 1, 3, ...): x^power increasing on R.
  #   - Even integers (..., -2, 0, 2, ...): x^power U-shaped.
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
  fraction <- power %% 1L
  if (fraction != 0) {
    stop(
      "Raising a series with negative values to a fractional power is not ",
      "supported, because the transformation results in complex numbers."
    )
  }
  remainder <- power %% 2L
  if (remainder == 1) {
    return(
      dsct_transform(
        x,
        fun = function(t) t^power,
        inv = function(t) {
          sign(t) * abs(t)^(1 / power)
        }
      )
    )
  }
  xpos <- dsct_keep(
    x,
    from = 0,
    to = Inf,
    include_from = TRUE,
    include_to = TRUE
  )
  xneg <- dsct_keep(
    x,
    from = -Inf,
    to = 0,
    include_from = TRUE,
    include_to = FALSE
  )
  ypos <- dsct_transform(
    xpos,
    fun = function(t) t^power,
    inv = function(t) t^(1 / power),
    domain = c(0, Inf),
    range = c(0, Inf)
  )
  yneg <- dsct_transform(
    xneg,
    fun = function(t) t^power,
    inv = function(t) -t^(1 / power),
    domain = c(-Inf, 0),
    range = c(0, Inf),
    dir = "decreasing"
  )
  dsct_union(ypos, yneg)
}