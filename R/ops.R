#' @export
Ops.discretes <- function(e1, e2) {
  op <- .Generic
  allowed <- c("+", "-", "*", "/", "^")

  if (!op %in% allowed) {
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
    stop("Operations between two discretes objects are not supported.")
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
    checkmate::assert_numeric(number, any.missing = FALSE, finite = FALSE)
    if (length(number) > 1) {
      stop("Cannot exponentiate a series by a vector of length >1.")
    }
    # Length-0 inputs yield an empty series
    if (num_discretes(dsct) == 0 || length(number) == 0) {
      return(dsct_empty(typeof(number ^ representative(dsct))))
    }

    old_type <- typeof(representative(dsct))
    new_type <- typeof(number ^ representative(dsct))

    # discretes^number
    if (e1_is_dsct) {
      if (number == 1 && old_type == new_type) {
        return(dsct)
      }
      if (number == 0) {
        return(dsct_numeric(1))
      }
      if (number < 0) {
        return(dsct_invert(dsct)^abs(number))
      }
      nonneg <- num_discretes(
        dsct,
        from = -Inf,
        to = 0,
        include_from = TRUE,
        include_to = FALSE
      ) == 0
      if (nonneg) {
        return(
          dsct_transform(
            dsct,
            fun = function(x) x^number,
            inv = function(x) x^(1 / number)
          )
        )
      }
      if (number %% 2 != 1) {
        stop(
          "Exponentiation of a discretes series is only supported for ",
          "odd powers."
        )
      }
      res <- dsct_transform(
        dsct,
        fun = function(x) x^number,
        inv = function(x) {
          sign(x) * abs(x)^(1 / number)
        }
      )
    }

    # number ^ discretes
    a <- number
    if (!is.finite(a)) {
      stop("For `number ^ discretes`, the base must be a finite, positive number.")
    }
    if (a <= 0) {
      stop("For `number ^ discretes`, the base must be a positive number.")
    }
    if (a == 1) {
      return(dsct_numeric(1))
    }

    # Special cases to avoid log()/exp() domain issues and match expectations.
    if (a == 0) {
      has_zero <- isTRUE(test_discrete(dsct, values = 0))
      has_pos <- length(next_discrete(dsct, from = 0, n = 1, include_from = FALSE)) > 0
      vals <- numeric(0)
      if (has_pos) vals <- c(vals, 0)
      if (has_zero) vals <- c(vals, 1)
      return(dsct_numeric(unique(vals)))
    }
    if (is.infinite(a)) {
      has_zero <- isTRUE(test_discrete(dsct, values = 0))
      has_pos <- length(next_discrete(dsct, from = 0, n = 1, include_from = FALSE)) > 0
      vals <- numeric(0)
      if (has_zero) vals <- c(vals, 1)
      if (has_pos) vals <- c(vals, Inf)
      return(dsct_numeric(unique(vals)))
    }

    if (a <= 0) {
      stop("Base must be positive when exponentiating a discretes series.")
    }
    if (a > 1) {
      return(
        dsct_transform(
          dsct,
          fun = function(x) exp(log(a) * x),
          inv = function(y) log(y) / log(a)
        )
      )
    }

    # 0 < a < 1: decreasing in exponent; represent as (1/a) ^ (-x)
    b <- 1 / a
    return(dsct_transform(
      dsct_negate(dsct),
      fun = function(x) exp(log(b) * x),
      inv = function(y) log(y) / log(b)
    ))
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
      return(dsct_linear(dsct, m = 1L / number))
    }
    if (e2_is_dsct) {
      return(dsct_linear(dsct_invert(e2), m = number))
    }
  }
  NextMethod()
}
