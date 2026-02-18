dsct_ln <- function(x) {
  checkmate::assert_true(is_discretes(x))
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
  dsct_transform(
    x,
    fun = log,
    inv = exp,
    domain = c(0, Inf)
  )
}

dsct_log <- function(dsct, base = exp(1)) {
  checkmate::assert_true(is_discretes(dsct))
  checkmate::assert_numeric(base, finite = TRUE)
  if (!length(base)) {
    return(dsct_empty(typeof(log(representative(x), base = base))))
  }
  if (base <= 0 || base == 1) {
    stop("Log base must be positive and not equal to 1.")
  }
  dsct_ln(dsct) / log(base)
}