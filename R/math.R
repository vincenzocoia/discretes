#' @noRd
#' @export
Math.discretes <- function(x, ...) {
  op <- .Generic # nolint
  allowed <- c("exp", "log", "log10", "log2")
  if (!op %in% allowed) {
    stop(sprintf("Math function '%s' is not supported for discretes objects.", op))
  }

  if (op == "exp") {
    ellipsis::check_dots_empty()
    if (num_discretes(x) == 0) {
      return(dsct_empty(typeof(exp(representative(x)))))
    }
    return(dsct_transform(x, fun = exp, inv = log))
  }

  # log variants
  dots <- list(...)
  if (op == "log") {
    if ("base" %in% names(dots)) {
      base <- dots[["base"]]
    } else {
      base <- exp(1)
    }
    dots[["base"]] <- NULL
    if (length(dots)) {
      stop("Unused arguments supplied to log().")
    }
  } else {
    ellipsis::check_dots_empty()
    base <- switch(op, log10 = 10, log2 = 2)
  }

  checkmate::assert_number(base, finite = TRUE)
  if (base <= 0 || base == 1) {
    stop("Log base must be positive and not equal to 1.")
  }

  if (num_discretes(x) == 0) {
    return(dsct_empty(typeof(log(representative(x), base = base))))
  }

  # Domain check: log is only defined (real-valued) for x >= 0.
  num_neg <- num_discretes(
    x,
    from = -Inf,
    to = 0,
    include_from = TRUE,
    include_to = FALSE
  )
  if (num_neg > 0) {
    stop("Series has negative values; cannot apply transform.")
  }

  if (base > 1) {
    return(
      dsct_transform(
        x,
        fun = function(t) log(t) / log(base),
        inv = function(t) exp(log(base) * t)
      )
    )
  }

  # 0 < base < 1: decreasing in x; represent as -log(z, base = 1/base)
  b <- 1 / base
  dsct_negate(
    dsct_transform(
      x,
      fun = function(t) log(t) / log(b),
      inv = function(t) exp(log(b) * t)
    )
  )
}

