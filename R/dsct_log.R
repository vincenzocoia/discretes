#' Logarithm of a numeric series
#'
#' Apply a logarithmic transformation to a numeric series for a given `base`.
#' `dsct_ln()` is the natural logarithm that uses base `exp(1)`.
#' Internal; use `log()` instead.
#'
#' @inheritParams next_discrete
#' @param base The base to use for the logarithm; numeric of length 0 or 1,
#'   with negative values and 1 not allowed (an error is thrown otherwise).
#' @returns A numeric series whose discrete values are the result of applying
#'   the logarithmic transformation `log()` to the discrete values of `x`
#'   with the specified base.
#' @examples
#' ## These are the same
#' discretes:::dsct_log(natural0(), base = exp(1))
#' log(natural0())
#' 
#' ## These are also the same
#' discretes:::dsct_log(natural0(), base = 10)
#' log(natural0(), base = 10)
#' log10(natural0())
#' @rdname logarithm
dsct_log <- function(x, base = exp(1)) {
  checkmate::assert_true(is_discrete_set(x))
  checkmate::assert_numeric(base, finite = TRUE)
  if (!length(base)) {
    return(empty_series(typeof(log(representative(x), base = base))))
  }
  if (base <= 0 || base == 1) {
    stop("Log base must be positive and not equal to 1.")
  }
  
  nneg <- num_discretes(
    x,
    from = -Inf,
    to = 0,
    include_from = TRUE,
    include_to = FALSE
  )
  if (nneg > 0) {
    stop("Series has negative values; cannot apply log transform.")
  }
  if (base < 1) {
    # Function is decreasing; cannot put into dsct_transform directly.
    res <- dsct_transform(
      x,
      fun = function(t) log(t, base = 1 / base),
      inv = function(t) exp(t * log(1 / base)),
      domain = c(0, Inf)
    )
    return(-res)
  }
  dsct_transform(
    x,
    fun = function(t) log(t, base = base),
    inv = function(t) exp(t * log(base)),
    domain = c(0, Inf)
  )
}
