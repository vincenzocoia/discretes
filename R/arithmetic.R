#' Arithmetic Series
#'
#' Construct an arithmetic progression, with possibly infinite values.
#' The progression is anchored at `representative` and extends `n_left` steps
#' to the left (decreasing values) and `n_right` steps to the right
#' (increasing values) with constant `spacing` between consecutive terms.
#'
#' @param representative Numeric scalar giving a known term in the progression.
#' @param spacing Non-negative numeric scalar describing the distance between
#'   adjacent terms.
#' @param ... Reserved for future extensions; must be empty.
#' @param n_left,n_right Non-negative counts (possibly `Inf`) describing how
#'   many steps exist to the left and right of `representative`.
#' @return A `dsct_arithmetic` object, inheriting from `discretes`.
#' @examples
#' arithmetic(representative = -0.6, spacing = 0.7)
#' arithmetic(representative = 0.6, spacing = 0.7, n_right = 0)
#' arithmetic(representative = 0, spacing = 2, n_left = 2, n_right = 2)
#' @export
arithmetic <- function(representative,
                       spacing,
                       ...,
                       n_left = Inf,
                       n_right = Inf) {
  checkmate::assert_number(representative)
  checkmate::assert_number(spacing, lower = 0)
  n_left <- assert_and_convert_integerish(n_left, lower = 0)
  n_right <- assert_and_convert_integerish(n_right, lower = 0)
  ellipsis::check_dots_empty()
  new_discretes(
    data = list(
      representative = representative,
      spacing = spacing,
      n_left = n_left,
      n_right = n_right
    ),
    subclass = "dsct_arithmetic"
  )
}



#' @export
representative_vectors <- function(x, len = 6) {
  UseMethod("representative_vectors")
}

#' @param len Representative vector lengths.
#' @export
representative_vectors.dsct_arithmetic <- function(x, len = 6) {
  representative <- x$representative
  if (x$spacing == 0) {
    # v <- representative
    # attr(v, "closed_left") <- TRUE
    # attr(v, "closed_right") <- TRUE
    # return(v)
    return(list(
      left = representative,
      middle = numeric(),
      right = representative
    ))
  }
  closed_left <- is.finite(x$n_left)
  closed_right <- is.finite(x$n_right)
  v_middle <- numeric()
  if (closed_left) {
    v_left <- next_discrete(x, from = -Inf, n = len)
  } else {
    v_left <- numeric()
    v_middle_left <- prev_discrete(x, from = representative, n = len)
    v_middle <- v_middle_left
  }
  if (closed_right) {
    v_right <- sort(prev_discrete(x, from = Inf, n = len))
  } else {
    v_right <- numeric()
    v_middle_right <- next_discrete(x, from = representative, n = len)
    v_middle <- append(v_middle, v_middle_right)
  }
  if (length(v_middle)) {
    v_middle <- sort(unique(v_middle))
    middle_length <- length(v_middle)
    rm <- max(middle_length - len, 0)
    rm_left <- floor(rm / 2)
    ikeep <- rm_left + seq_len(len)
    v_middle <- v_middle[ikeep]
  }

  # attr(v, "closed_left") <- closed_left
  # attr(v, "closed_right") <- closed_right
  new_rvecs(
    left = v_left,
    middle = v_middle,
    right = v_right,
    len = len
  )
}

#' Representative Vectors
#'
#' `new_rvecs()` checks that the representative vectors are appropriate:
#' exactly one of `left`, `middle`, and `right` is a length-0 vector;
#' exactly two are length-`len`. And, it makes sure the vectors are sorted
#' from smallest to largest.
#' @noRd
new_rvec <- function(x, closed = c("both", "left", "right", "none")) {
  checkmate::assert_numeric(x)
  closed <- match.arg(closed)
  attr(x, "closed") <- closed
  x
}

#' @export
representative_vector <- function(x, len = 6) {
  UseMethod("representative_vector")
}

#' @param len Representative vector length when there are infinite discretes.
#' Can be `Inf`, in which case the whole series will be returned as a vector.
#' @export
representative_vector.dsct_arithmetic <- function(x, len = 6) {
  checkmate::assert_integerish(len, lower = 0, any.missing = FALSE)
  # General code for finite series
  n <- num_discretes(x)
  if (is.finite(n)) {
    v <- discretes_between(x)
    return(new_rvec(v, "both"))
  }
  if (is.infinite(len)) {
    stop("Cannot get the entire series as it has infinite length.")
  }
  # ----- Specific code for infinite arithmetic series -----
  closed_left <- is.finite(x$n_left)
  closed_right <- is.finite(x$n_right)
  representative <- x$representative
  if (closed_left && !closed_right) {
    v <- next_discrete(x, from = -Inf, n = len)
    return(new_rvec(v, "left"))
  }
  if (!closed_left && closed_right) {
    v <- sort(prev_discrete(x, from = Inf, n = len))
    return(new_rvec(v, "right"))
  }
  left <- prev_discrete(x, from = representative, n = len)
  right <- next_discrete(x, from = representative, n = len)
  v <- sort(unique(append(left, right)))
  v_len <- length(v)
  excess <- v_len - len
  if (excess > 0) {
    rm_left <- ceiling(excess / 2)
    ikeep <- rm_left + seq_len(len)
    v <- v[ikeep]
  }
  return(new_rvec(v, "none"))
}

