#' @export
Ops.discretes <- function(e1, e2) {
  op <- .Generic
  allowed <- c("+", "-", "*", "/")

  if (!op %in% allowed) {
    stop(sprintf("Operator '%s' is not supported for discretes objects.", op))
  }

  unary <- missing(e2)
  if (unary) {
    res <- switch(
      op,
      "+" = e1,
      "-" = dsct_linear(e1, m = -1, b = 0),
      stop(
        sprintf("Unary operator '%s' is not supported for discretes objects.", op)
      )
    )
    return(res)
  }

  inf1 <- inherits(e1, "discretes")
  inf2 <- inherits(e2, "discretes")

  if (inf1 && inf2) {
    stop("Operations between two discretes objects are not supported.")
  }
  checkmate::assert_true(inf1 || inf2)
  if (inf1) {
    checkmate::assert_number(e2, na.ok = FALSE)
    iv <- e1
    number <- e2
  }
  if (inf2) {
    checkmate::assert_number(e1, na.ok = FALSE)
    iv <- e2
    number <- e1
  }

  if (op == "+") {
    return(dsct_linear(iv, m = 1, b = number))
  }

  if (op == "-") {
    if (inf1) {
      return(dsct_linear(iv, m = 1, b = -number))
    }
    if (inf2) {
      return(dsct_linear(iv, m = -1, b = number))
    }
  }

  if (op == "*") {
    return(dsct_linear(iv, m = number, b = 0))
  }

  if (op == "/") {
    if (inf1) {
      if (number == 0) {
        stop("Division of a discretes object by zero is undefined.")
      }
      return(dsct_linear(iv, m = 1 / number, b = 0))
    }
    if (inf2) {
      if (test_discrete(e2, 0)) {
        stop("Division of zero by a discretes object is not yet defined.")
      }
      return(dsct_invert(dsct_linear(e2, m = 1 / number, b = 0)))
    }
  }
  NextMethod()
}
