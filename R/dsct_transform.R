#' Monotonically Transform a Discrete Value Series
#'
#' @inheritParams next_discrete
#' @param fun,inv A vectorized, strictly increasing function to apply to the
#'   discrete support values, and its inverse, `inv`.
#' @param domain,range Numeric vectors of length 2, indicating the domain and
#'   range of `fun` (that is, the interval on which `fun` is valid, and the
#'   interval in which `fun` maps to).
#' @param dir A string, either "increasing" or "decreasing", indicating the
#'   monotonicity of the function `fun`.
#' @returns A transformed discretes object.
#' @note The onus is on the user to ensure that `inv` is indeed the inverse of
#'   `fun`, that both are vectorized.
#' @details
#' Strictly increasing means that for any `x1 < x2`, it holds that
#'   `fun(x1) < fun(x2)`, for all values on the real line. The function `-1/x`,
#'   for example, is not strictly increasing: its derivative is increasing,
#'   but switches to smaller values after `x = 0`, therefore is not strictly
#'   increasing.
#'
#' If a decreasing function is provided, the transformation is negated
#'   internally first: that is, the input series is negated, and the
#'   function and its inverse are modified accordingly.
#' @examples
#' dsct_transform(integers(), fun = pnorm, inv = qnorm, range = c(0, 1))
#' @family transformations
#' @export
dsct_transform <- function(x,
                           fun,
                           inv,
                           ...,
                           domain = c(-Inf, Inf),
                           range = c(-Inf, Inf),
                           dir = c("increasing", "decreasing")) {
  UseMethod("dsct_transform")
}

#' @export
dsct_transform.discretes <- function(x,
                                     fun,
                                     inv,
                                     ...,
                                     domain = c(-Inf, Inf),
                                     range = c(-Inf, Inf),
                                     dir = c("increasing", "decreasing")) {
  checkmate::assert_function(fun)
  checkmate::assert_function(inv)
  ellipsis::check_dots_empty()
  checkmate::assert_numeric(domain, len = 2, any.missing = FALSE)
  checkmate::assert_numeric(range, len = 2, any.missing = FALSE)
  checkmate::assert_number(domain[2], lower = domain[1])
  checkmate::assert_number(range[2], lower = range[1])
  dir <- rlang::arg_match(dir)
  if (dir == "decreasing") {
    return(
      dsct_transform(
        -x,
        fun = function(t) fun(-t),
        inv = function(t) -inv(t),
        domain = -rev(domain),
        range = range,
        dir = "increasing"
      )
    )
  }
  validate_transform_fun(fun, inv, domain = domain, range = range)
  ntotal <- num_discretes(x)
  if (ntotal == 0) {
    return(empty_set(typeof(fun(representative(x)))))
  }
  nleft <- num_discretes(
    x,
    from = -Inf,
    to = domain[1],
    include_from = TRUE,
    include_to = FALSE
  )
  nright <- num_discretes(
    x,
    from = domain[2],
    to = Inf,
    include_from = FALSE,
    include_to = TRUE
  )
  if (nleft + nright > 0) {
    warning(
      "Detected values outside of the transformation function's domain that ",
      "are meant to be transformed. Did you misspecify the function's ",
      "domain?"
    )
  }
  sinkmat <- sinks(x)
  sinkmat[, "location"] <- fun(sinkmat[, "location"])
  new_dsct_transform(
    data = list(
      base = x,
      fun = fun,
      inv = inv,
      domain = domain,
      range = range
    ),
    name = "Transformed",
    sinks = sinkmat
  )
}
