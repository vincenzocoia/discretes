#' @export
print.discretes <- function(x, len = 6, ...) {
  cat("Series of length ", num_discretes(x), ":\n", sep = "")
  v <- representative_vector(x, len = len)
  closed <- attr(v, "closed")
  if (closed == "none") {
    cat("...", v, "...", sep = ", ")
    return(invisible(x))
  }
  if (closed == "left") {
    cat(v, "...", sep = ", ")
    return(invisible(x))
  }
  if (closed == "right") {
    cat("...", v, sep = ", ")
    return(invisible(x))
  }
  if (closed == "both") {
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
    return(invisible(x))
  }
  cat("(Could not find representative values.)")
}

