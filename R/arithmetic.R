#' @export
arithmetic <- function(representative, spacing, ..., n_left = Inf, n_right = Inf) {
  checkmate::assert_number(representative)
  checkmate::assert_number(spacing, lower = 0)
  checkmate::assert_number(n_left, lower = 0)
  checkmate::assert_number(n_right, lower = 0)
  ellipsis::check_dots_empty()
  if (!is.infinite(n_left)) {
    checkmate::assert_integerish(n_left)
  }
  if (!is.infinite(n_right)) {
    checkmate::assert_integerish(n_right)
  }
  new_infvctr(
    subclass = "arithmetic_infvctr",
    data = list(
      representative = representative,
      spacing = spacing,
      n_left = n_left,
      n_right = n_right
    )
  )
}

#' @export
print.arithmetic_infvctr <- function(x, ...) {
  cat("Arithmetic infvctr:\n")
  if (x$n_left == Inf && x$n_right == Inf) {
    p <- x$representative + (-2:2) * x$spacing
    cat("..., ", paste(p, collapse = ", "), " ...\n", sep = "")
  } else if (x$n_left == Inf) {
    p <- x$representative + (-4:0 + x$n_right) * x$spacing
    cat("..., ", paste(p, collapse = ", "), "\n", sep = "")
  } else if (x$n_right == Inf) {
    p <- x$representative + (0:4 - x$n_left) * x$spacing
    cat(paste(p, collapse = ", "), ", ...\n", sep = "")
  } else if (x$n_right + x$n_left > 5) {
    p_left <- x$representative + (-2:0 + x$n_left) * x$spacing
    p_right <- x$representative + (0:2 + x$n_right) * x$spacing
    cat(
      paste(p_left, collapse = ", "), ", ..., ",
      paste(p_right, collapse = ", "), "\n", sep = ""
    )
  } else {
    p <- x$representative + (-x$n_left:x$n_right) * x$spacing
    cat(paste(p, collapse = ", "), "\n", sep = "")
  }
  invisible(x)
}
