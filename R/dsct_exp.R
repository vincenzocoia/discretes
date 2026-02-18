dsct_exp <- function(x) {
  dsct_transform(
    x,
    fun = exp,
    inv = log,
    range = c(0, Inf)
  )
}

dsct_raise <- function(x, base = exp(1)) {
  checkmate::assert_true(is_discretes(x))
  checkmate::assert_numeric(base, any.missing = FALSE, finite = FALSE)
  if (!length(base)) {
    return(dsct_empty(typeof(representative(x)^base)))
  }
  if (length(base) > 1) {
    stop("Cannot exponentiate a series by a vector of length >1.")
  }
  if (base < 0) {
    stop("Exponentiating a discrete set with a negative base is not supported.")
  }
  if (base == 1) {
    return(dsct_numeric(1))
  }
  if (base == 0 || base == Inf) {
    has_zero <- test_discrete(x, values = 0)
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
    return(dsct_numeric(vals))
  }
  dsct_transform(
    x,
    fun = function(x) base^x,
    inv = function(x) log(x, base = base),
    range = c(0, Inf)
  )
}