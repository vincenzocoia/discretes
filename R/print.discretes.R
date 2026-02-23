#' Print method for "discretes" objects
#' 
#' Print a "discretes" object to screen.
#' 
#' @inheritParams next_discrete
#' @param len Number of discrete values to display.
#' @param ... Further arguments to pass to downstream methods; currently not
#'   used.
#' @returns Invisibly returns the input object `x`.
#' @examples
#' print(integers())
#' print(1 / natural1())
#' print(-1 / natural1())
#' print(1 / integers())
#' print(1 / integers(), len = 1)
#' print(1 / integers(), len = 0)
#' @export
print.discretes <- function(x, len = 6, ...) {
  len <- assert_and_convert_integerish(len, lower = 0)
  ellipsis::check_dots_empty()
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
  cat(nm, series, " of length ", n, sep = "")

  if (len > 0) {
    cat(":\n")
  } else {
    cat(".\n")
    return(invisible(x))
  }
  
  if (len == 1) {
    rpr <- representative(x)
    if (num_discretes(x, from = -Inf, to = rpr, include_to = FALSE)) {
      cat("..., ")
    }
    cat(rpr)
    if (num_discretes(x, from = rpr, to = Inf, include_from = FALSE)) {
      cat(", ...")
    }
    cat("\n")
    return(invisible(x))
  }
  
  # Finite Series
  if (is.finite(n)) {
    v <- get_discretes_in(x)
    excess <- n - len
    if (excess > 0) {
      nleft <- floor(len / 2)
      nright <- ceiling(len / 2)
      ikeep_left <- seq_len(nleft)
      ikeep_right <- sort(n - (seq_len(nright) - 1))
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

  # Closed on at least one side
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
  if (closed_left && closed_right) {
    nleft <- floor(len / 2)
    nright <- ceiling(len / 2)
    cat(
      utils::head(series_first, nleft),
      "...",
      utils::tail(series_last, nright),
      sep = ", "
    )
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
