# Simple checks on the input function `fun` and its inverse, `inv`,
# for `dsct_transform()`. Run for its `warning()` side effects; returns
# `fun` invisibly. See `dsct_transform()` for the inputs.
validate_transform_fun <- function(fun, inv, domain, range) {
  orig_domain <- domain
  if (all(is.infinite(domain))) {
    domain <- c(-1, 1)
  }
  if (domain[1] == -Inf) {
    domain[1] <- domain[2] - 1
  }
  if (domain[2] == Inf) {
    domain[2] <- domain[1] + 1
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
  # Also flag a `range` that is wider than the function's image. For an
  # increasing `fun`, the image endpoints are `fun()` at the domain endpoints,
  # evaluated directly (R returns the correct limit at +/-Inf for the monotonic
  # functions used here, e.g. `tanh(Inf) == 1`). An unbounded image yields an
  # infinite bound, so the comparison never fires for it; only a finite image
  # bound that the range overshoots warns. This treats finite and infinite
  # range bounds the same.
  tol <- .Machine$double.eps^0.5
  image_lower <- try(fun(orig_domain[1]), silent = TRUE)
  if (
    !inherits(image_lower, "try-error") &&
      !is.na(image_lower) &&
      range[1] < image_lower - tol
  ) {
    warning(
      "The specified range's lower bound (",
      range[1],
      ") is below the ",
      "function's image, which starts near ",
      image_lower,
      "."
    )
  }
  image_upper <- try(fun(orig_domain[2]), silent = TRUE)
  if (
    !inherits(image_upper, "try-error") &&
      !is.na(image_upper) &&
      range[2] > image_upper + tol
  ) {
    warning(
      "The specified range's upper bound (",
      range[2],
      ") is above the ",
      "function's image, which ends near ",
      image_upper,
      "."
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
