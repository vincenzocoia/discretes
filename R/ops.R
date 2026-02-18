#' @export
Ops.discretes <- function(e1, e2) {
  op <- .Generic
  allowed <- c("+", "-", "*", "/", "^")

  if (!(op %in% allowed)) {
    stop(sprintf("Operator '%s' is not supported for discretes objects.", op))
  }

  unary <- missing(e2)
  if (unary) {
    res <- switch(
      op,
      "+" = e1,
      "-" = dsct_negate(e1),
      stop(
        sprintf(
          "Unary operator '%s' is not supported for discretes objects.", op
        )
      )
    )
    return(res)
  }

  e1_is_dsct <- inherits(e1, "discretes")
  e2_is_dsct <- inherits(e2, "discretes")

  if (e1_is_dsct && e2_is_dsct) {
    stop("Operations between two 'discretes' objects are not supported.")
  }

  if (e1_is_dsct) {
    dsct <- e1
    number <- e2
  }
  if (e2_is_dsct) {
    dsct <- e2
    number <- e1
  }

  if (op == "^") {
    # discretes^number
    if (e1_is_dsct) {
      return(dsct_power(dsct, power = number))
    }
    # number^discretes
    return(dsct_raise(dsct, base = number))
  }

  if (op == "+") {
    return(dsct_linear(dsct, m = 1L, b = number))
  }

  if (op == "-") {
    if (e1_is_dsct) {
      return(dsct_linear(dsct, m = 1L, b = -number))
    }
    if (e2_is_dsct) {
      return(dsct_linear(dsct, m = -1L, b = number))
    }
  }

  if (op == "*") {
    return(dsct_linear(dsct, m = number))
  }

  if (op == "/") {
    if (e1_is_dsct) {
      return(dsct_linear(dsct, m = 1 / number))
    }
    if (e2_is_dsct) {
      return(dsct_linear(dsct_invert(e2), m = number))
    }
  }
  NextMethod()
}
