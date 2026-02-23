#' @export
next_discrete.dsct_inverse <- function(x,
                                       from,
                                       ...,
                                       n = 1L,
                                       include_from = FALSE,
                                       tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_number(from)
  ellipsis::check_dots_empty()
  n <- assert_and_convert_integerish(n, lower = 0)
  checkmate::assert_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::assert_number(tol, lower = 0)
  base <- x$base
  collected <- vector(length = 0, mode = typeof(representative(x)))
  encountered_sink <- FALSE
  if (n == 0) {
    return(collected)
  }
  # The strategy is to move from left to right in segments:
  # 1. -Inf
  # 2. Negative values
  # 3. 0
  # 4. Positive values
  # 5. Inf
  # Only move forward if there's positive `n`, and we haven't reached a sink.
  if (from == -Inf && include_from) {
    to_add <- -Inf[has_discretes(x, values = -Inf)]
    collected <- append(collected, to_add)
    include_from <- FALSE
    n <- n - length(to_add)
  }
  if (n > 0 && from < 0) {
    newx <- prev_discrete(
      base,
      from = 1 / from,
      n = n,
      include_from = include_from,
      tol = tol
    )
    # Remove -Inf if present in the base; this maps to 0 and is treated next.
    newx <- newx[is.finite(newx)]
    collected <- append(collected, 1 / newx)
    # Update configuration
    n <- max(0, n - length(newx))
    encountered_sink <- has_sink(x, from = from, to = 0)
    from <- 0
    include_from <- TRUE
  }
  if (n > 0 && !encountered_sink && from == 0 && include_from) {
    base_infs <- has_discretes(base, values = c(-Inf, Inf))
    if (base_infs[1] && !base_infs[2]) {
      collected <- append(collected, -0)
      n <- n - 1
    } else if (any(base_infs)) {
      collected <- append(collected, 0)
      n <- n - 1
    }
    include_from <- FALSE
  }
  if (n > 0 && !encountered_sink && from >= 0 && from < Inf) {
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
    encountered_sink <- has_sink(x, from = from)
    from <- Inf
    include_from <- TRUE
  }
  if (n > 0 && !encountered_sink && from == Inf && include_from) {
    collected <- append(collected, Inf[has_discretes(x, values = Inf)])
  }
  collected
}
