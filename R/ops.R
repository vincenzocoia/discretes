#' @export
Ops.infvctr <- function(e1, e2) {
  op <- .Generic
  allowed <- c("+", "-", "*", "/")

  if (!op %in% allowed) {
    stop(sprintf("Operator '%s' is not supported for infvctr objects.", op), call. = FALSE)
  }

  unary <- missing(e2)
  if (unary) {
    switch(
      op,
      "+" = e1,
      "-" = iv_negate(e1),
      stop(sprintf("Unary operator '%s' is not supported for infvctr objects.", op), call. = FALSE)
    )
  }

  inf1 <- inherits(e1, "infvctr")
  inf2 <- inherits(e2, "infvctr")

  if (inf1 && inf2) {
    stop("Operations between two infvctr objects are not supported.")
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
    return(iv_shift(iv, number))
  }

  if (op == "-") {
    if (inf1) {
      return(iv_shift(iv, -number))
    }
    if (inf2) {
      return(iv_shift(iv_negate(iv), number))
    }
  }

  if (op == "*") {
    return(iv_multiply(iv, number))
  }

  if (op == "/") {
    if (inf1) {
      if (number == 0) {
        stop("Division of an infvctr by zero is undefined.")
      }
      return(iv_multiply(iv, 1 / number))
    }
    if (inf2) {
      if (e2 == 0) {
        stop("Division of zero by an infvctr is not yet defined.")
      }
      return(iv_multiply(iv_invert(e2), e1))
    }
  }

  NextMethod()
}


