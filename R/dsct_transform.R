#' Monotonically Transform a Discrete Value Series
#'
#' @inheritParams dsct_negate
#' @param fun,inv A vectorized, strictly increasing function to apply to the
#'   discrete support values, and its inverse, `inv`.
#' @param domain,range Numeric vectors of length 2, indicating the domain and
#'   range of `fun` (that is, the interval on which `fun` is valid, and the
#'   interval in which `fun` maps to).
#' @returns A transformed discretes object.
#' @note The onus is on the user to ensure that `inv` is indeed the inverse of
#'   `fun`, that both are vectorized, and that both are strictly increasing.
#' 
#' By strictly increasing, we mean that for any `x1 < x2`, it holds that
#'   `fun(x1) < fun(x2)`, for all values on the real line. The function `-1/x`,
#'   for example, is not strictly increasing: its derivative is increasing,
#'   but switches to smaller values after `x = 0`, therefore is not strictly
#'   increasing. This becomes important when distinguishing between `+0`
#'   and `-0`, which has special treatment with `dsct_inverse()`, but not
#'   for `dsct_transform()`.
#' @examples
#' dsct_transform(integers(), fun = exp, inv = log)
#' @family transformations
#' @export
dsct_transform <- function(x,
                           fun,
                           inv,
                           domain = c(-Inf, Inf),
                           range = c(-Inf, Inf)) {
  UseMethod("dsct_transform")
}

#' @noRd
#' @export
dsct_transform.discretes <- function(x,
                                     fun,
                                     inv,
                                     domain = c(-Inf, Inf),
                                     range = c(-Inf, Inf)) {
  checkmate::assert_function(fun)
  checkmate::assert_function(inv)
  checkmate::assert_numeric(domain, len = 2, any.missing = FALSE)
  checkmate::assert_numeric(range, len = 2, any.missing = FALSE)
  checkmate::assert_number(domain[2], lower = domain[1])
  checkmate::assert_number(range[2], lower = range[1])
  validate_transform_fun(fun, inv, domain = domain, range = range)
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
  new_discretes(
    data = list(
      base = x,
      fun = fun,
      inv = inv,
      domain = domain,
      range = range
    ),
    name = "Transformed",
    sinks = sinkmat,
    subclass = "dsct_transform"
  )
}

# Simple checks on the input function `fun` and its inverse, `inv`,
# for `dsct_transform()`.
validate_transform_fun <- function(fun, inv, domain, range) {
  if (all(is.infinite(domain))) {
    domain <- c(-2, 2)
  }
  if (domain[1] == -Inf) {
    domain[1] <- domain[2] - 5
  }
  if (domain[2] == Inf) {
    domain[2] <- domain[1] + 5
  }
  middle <- try(fun(mean(domain)), silent = TRUE)
  if (inherits(middle, "try-error")) {
    warning("Function errors when evaluated at ", mean(domain))
  }
  x <- seq(domain[1], domain[2], length.out = 5)
  rng <- try(fun(x), silent = TRUE)
  if (inherits(rng, "try-error")) {
    warning(
      "Function errors when evaluated at the vector c(",
      paste(x, collapse = ", "),
      "); perhaps your function is not vectorized?"
    )
  }
  na <- is.na(rng)
  if (any(na)) {
    warning(
      "Function evaluates to NA when evaluated at ",
      paste(x[na], collapse = ", "),
      "."
    )
  }
  if (any(diff(rng[!na]) <= 0)) {
    warning(
      "Function is not strictly increasing when evaluated at the vector c(",
      paste(x, collapse = ", "),
      ")."
    )
  }
  if (any(!is_between(rng[!na], lower = range[1], upper = range[2]))) {
    warning(
      "Function does not evaluate to within the specified range: ",
      paste(range, collapse = ", ")
    )
  }
  x2 <- try(inv(rng[!na]), silent = TRUE)
  if (inherits(x2, "try-error")) {
    warning(
      "Inverse function `inv` errors when evaluated at the vector c(",
      paste(rng[!na], collapse = ", "),
      ")."
    )
  }
  if (!all(abs(x[!na] - x2) < .Machine$double.eps^0.5)) {
    warning(
      "Inverse function `inv` does not appear to be the inverse of `fun` ",
      "when evaluated at the vector c(",
      paste(x, collapse = ", "),
      ")."
    )
  }
  invisible(fun)
}
