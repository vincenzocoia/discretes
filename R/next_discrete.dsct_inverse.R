#' @noRd
#' @export
next_discrete.dsct_inverse <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = TRUE,
                                       tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  base <- x$base
  collected <- vector(length = 0, mode = typeof(representative(x)))
  if (n == 0) {
    return(collected)
  }
  # The strategy is to move from left to right in segments:
  # 1. -Inf
  # 2. Negative values
  # 3. 0
  # 4. Positive values
  # 5. Inf
  if (from == -Inf && include_from) {
    collected <- append(collected, -Inf[test_discrete(x, values = -Inf)])
    include_from <- FALSE
    n <- n - 1
  }
  if (n > 0 && from < 0) {
    newx <- prev_discrete(
      base,
      from = 1 / from,
      n = n,
      include_from = include_from,
      tol = tol
    )
    # Remove -Inf if present; will be treated separately next.
    newx <- newx[is.finite(newx)]
    collected <- append(collected, 1 / newx)
    # Update configuration
    n <- max(0, n - length(newx))
    from <- 0
    include_from <- TRUE
  }
  if (n > 0 && from == 0 && include_from) {
    base_infs <- test_discrete(base, values = c(-Inf, Inf))
    if (base_infs[1] && !base_infs[2]) {
      collected <- append(collected, -0)
      n <- n - 1
    } else if (any(base_infs)) {
      collected <- append(collected, 0)
      n <- n - 1
    }
    include_from <- FALSE
  }
  if (n > 0 && from >= 0) {
    upper_bound <- 1 / abs(from)  # abs() in case from = -0.
    n_available <- num_discretes( # Don't want to go left of 0 on the base.
      base,
      from = 0,
      to = upper_bound,
      include_from = FALSE,
      include_to = include_from,
      tol = tol
    )
    n_pos <- min(n, n_available)
    newx <- prev_discrete(
      base,
      from = upper_bound,
      n = n_pos,
      include_from = include_from,
      tol = tol
    )
    collected <- append(collected, 1 / newx)
    n <- n - length(newx)
    from <- Inf
    include_from <- TRUE
  }
  if (n > 0 && from == Inf && include_from) {
    collected <- append(collected, Inf[test_discrete(x, values = Inf)])
  }
  collected
}


# next_discrete.dsct_inverse <- function(x,
#                                        from,
#                                        ...,
#                                        n = 1L,
#                                        include_from = TRUE,
#                                        tol = sqrt(.Machine$double.eps)) {
#   checkmate::assert_number(from)
#   ellipsis::check_dots_empty()
#   n <- assert_and_convert_integerish(n, lower = 0)
#   checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
#   checkmate::assert_number(tol, lower = 0)
#   if (n == 0) {
#     return(vector(length = 0, mode = typeof(representative(x))))
#   }
#   base <- x$base
#   if (from >= 0) { # Grab discretes only on [+0, 1 / from)] going left.
#     upper_bound <- 1 / abs(from)  # abs() in case from = -0.
#     n_available <- num_discretes(
#       base,
#       from = 0,
#       to = upper_bound,
#       include_from = FALSE,
#       include_to = include_from,
#       tol = tol
#     )
#     n_available <- n_available + has_positive_zero(base)
#     n <- min(n, n_available)
#     collected <- prev_discrete(
#       base,
#       from = upper_bound,
#       n = n,
#       include_from = include_from,
#       tol = tol
#     )
#     # If zero was collected, it must be +0, but it's possible -0 gets collected
#     # if that's what gets expressed in the base series.
#     collected <- abs(collected)
#   } else {
#     # Grab discretes going left,
#     # - first on (-Inf, 1 / from)], then
#     # - grab +0 if either -Inf or Inf belong to the base, or -0 if only -Inf;
#     # - finally on [0, Inf). 
#     if (include_from) {
#       collected <- from[test_discrete(base, values = from)]
#     }
#     collected <- prev_discrete(
#       base,
#       from = 1 / from, # supplied_from = -Inf, then arg_from = 0, but must be expressed as -0.
#       n = n,
#       include_from = include_from,
#       tol = tol
#     )
#     n_remaining <- n - length(collected)
#     n_available <- num_discretes(
#       base,
#       from = 0,
#       to = Inf,
#       include_from = FALSE,
#       include_to = FALSE,
#       tol = tol
#     )
#     n_remaining <- min(n_available, n_remaining)
#     extra <- prev_discrete(
#       base,
#       from = Inf,
#       n = n_remaining,
#       include_from = FALSE,
#       tol = tol
#     )
#     collected <- append(collected, extra)
#   }
#   reciprocals <- 1 / collected
#   sort(reciprocals)
# }
