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
