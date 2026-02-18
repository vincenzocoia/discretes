# Discrete^power
dsct_power <- function(dsct, power) {
  checkmate::assert_true(is_discretes(dsct))
  checkmate::assert_numeric(power, any.missing = FALSE, finite = FALSE)
  if (length(power) > 1) {
    stop("Cannot exponentiate a series by a vector of length >1.")
  }
  if (num_discretes(dsct) == 0 || length(power) == 0) {
    return(dsct_empty(typeof(representative(dsct)^power)))
  }
  old_type <- typeof(representative(dsct))
  new_type <- typeof(representative(dsct)^power)
  if (power == 1 && old_type == new_type && !has_negative_zero(dsct)) {
    # Note: (-0)^1 = +0, which is why we need the negative zero check here.
    return(dsct)
  }
  if (power == 0) {
    return(dsct_numeric(1))
  }
  if (power < 0) {
    return(dsct_invert(dsct)^abs(power))
  }
  nneg <- num_discretes(
    dsct,
    from = -Inf,
    to = 0,
    include_from = TRUE,
    include_to = FALSE
  )
  if (nneg == 0) {
    return(
      dsct_transform(
        dsct,
        fun = function(x) x^power,
        inv = function(x) x^(1 / power),
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
    dsct,
    fun = function(x) x^power,
    inv = function(x) {
      sign(x) * abs(x)^(1 / power)
    }
  )
}