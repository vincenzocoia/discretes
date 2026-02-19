#' @noRd
#' @export
Math.discretes <- function(x, ...) {
  op <- .Generic # nolint
  allowed <- c("exp", "log", "log10", "log2", "sqrt")
  if (!(op %in% allowed)) {
    stop(
      sprintf("Math function '%s' is not supported for discretes objects.", op)
    )
  }
  
  if (op == "exp") {
    ellipsis::check_dots_empty()
    return(dsct_exp(x))
  }
  
  if (op == "sqrt") {
    ellipsis::check_dots_empty()
    return(dsct_power(x, power = 0.5))
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
  return(dsct_log(x, base = base))
}

