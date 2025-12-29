#' Integers
#'
#' Create an object representing the set of integers within a specified range.
#' @param from,to Numeric values defining the inclusive range of integers.
#' Defaults to `-Inf` and `Inf`, representing all integers.
#' @returns An object of class `intgrs`, representing the set of integers
#' within the specified range.
#' @examples
#' integers()          # All integers
#' integers(from = 0) # Non-negative integers
#' integers(to = 0)   # Non-positive integers
#' integers(from = -5, to = 5) # Integers from -5
#' @export
integers <- function(from = -Inf, to = Inf) {
  checkmate::assert_number(from, finite = FALSE)
  checkmate::assert_number(to, lower = from, finite = FALSE)
  checkmate::assert_true(to > -Inf && from < Inf)
  x <- list(lower = from, upper = to)
  structure(x, class = "intgrs")
}

#' @export
print.intgrs <- function(x, ...) {
  cat("Integer Vector\n")
  if (x$lower == -Inf && x$upper == Inf) {
    cat("..., -2, -1, 0, 1, 2, ...\n")
  } else if (x$lower == -Inf) {
    v <- x$upper - 4:0
    cat("..., ", paste(v, collapse = ", "), "\n", sep = "")
  } else if (x$upper == Inf) {
    v <- x$lower + 0:4
    cat(paste(v, collapse = ", "), " ...\n", sep = "")
  } else {
    cat(
      x$lower, ", ", x$lower + 1, ", ", x$lower + 2, ", ..., ",
      x$upper - 2, ", ", x$upper - 1, ", ", x$upper, "\n", sep = ""
    )
  }
  invisible(x)
}

#' @export
next_discrete.intgrs <- function(x, from, ..., n = 1, include_from = TRUE) {
  checkmate::assert_numeric(from, len = 1)
  checkmate::assert_integerish(n, lower = 0, len = 1)
  checkmate::assert_logical(include_from, len = 1)
  ellipsis::check_dots_empty()
  if (from == Inf) {
    return(numeric(0L))
  }
  if (from < x$lower) {
    from <- x$lower
    include_from <- TRUE
  }
  if (from == -Inf) {
    # Also x$lower = -Inf in this case because of the previous if statement.
    stop("No defined next value when searching behind an infinite series.")
  }
  floor_from <- floor(from)
  adjust <- from == floor_from && include_from
  res <- floor_from + seq_len(n) - adjust
  res[res <= x$upper]
}
