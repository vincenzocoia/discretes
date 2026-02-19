#' @export
print.discretes <- function(x, len = 6, ...) {
  len <- assert_and_convert_integerish(len, lower = 0)
  n <- num_discretes(x)
  if (n == 0) {
    cat("Empty series.\n")
    return(invisible(x))
  }
  nm <- attr(x, "name")
  if (is.null(nm)) {
    series <- "Series"
  } else {
    series <- " series"
  }
  cat(nm, series, " of length ", n, ":\n", sep = "")

  # Finite Series
  if (is.finite(n)) {
    v <- get_discretes_in(x)
    v_len <- length(v)
    excess <- v_len - len
    if (excess > 0) {
      nleft <- floor(len / 2)
      nright <- ceiling(len / 2)
      ikeep_left <- seq_len(nleft)
      ikeep_right <- sort(v_len - (seq_len(nright) - 1))
      vleft <- v[ikeep_left]
      vright <- v[ikeep_right]
      cat(vleft, "...", vright, sep = ", ")
    } else {
      cat(v, sep = ", ")
    }
    cat("\n")
    return(invisible(x))
  }
  if (is.infinite(len)) {
    stop("Cannot print the entire series as it has infinite length.")
  }

  # Which sides are closed?
  series_first <- next_discrete(x, from = -Inf, n = len, include_from = TRUE)
  series_last <- sort(
    prev_discrete(x, from = Inf, n = len, include_from = TRUE)
  )
  closed_left <- as.logical(length(series_first))
  closed_right <- as.logical(length(series_last))

  # Closed on one side
  if (closed_left && !closed_right) {
    v <- series_first
    cat(v, "...\n", sep = ", ")
    return(invisible(x))
  }
  if (!closed_left && closed_right) {
    v <- series_last
    cat("...", v, sep = ", ")
    cat("\n")
    return(invisible(x))
  }

  # Closed on neither side
  representative <- representative(x)
  left <- prev_discrete(x, from = representative, n = len, include_from = TRUE)
  right <- next_discrete(x, from = representative, n = len, include_from = TRUE)
  v <- sort(unique(append(left, right)))
  v_len <- length(v)
  excess <- v_len - len
  if (excess > 0) {
    rm_left <- ceiling(excess / 2)
    ikeep <- rm_left + seq_len(len)
    v <- v[ikeep]
  }
  cat("...", v, "...\n", sep = ", ")
  invisible(x)
}
