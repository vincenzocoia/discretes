#' Subset a numeric series by position
#'
#' When a series has a well-defined "first" element (e.g. `natural1()` starts at
#' 1), subsetting with `[]` materializes a specified part of the series, and
#' mirrors the behaviour of numeric vector subsetting. 
#' Positive `i` returns the discrete values at those positions, and
#' negative `i` tries to return the full series with the specified positions
#' dropped.
#'
#' @param x A numeric series (object of class `"discretes"`).
#' @param i Numeric vector of indices. Omit for the
#'   full series (finite only).
#' @param value Replacement value; ignored, because replacement via `[<-` is not
#'   supported.
#' @returns A vector of discrete values. When the series has no first element or
#'   too few values for positive `i`, R returns NA as for ordinary vectors.
#'   For negative `i` or missing `i`, the full series is obtained first;
#'   infinite series behaviour defaults to that of `get_discretes_in()`.
#' @note
#' Unlike subsetting numeric vectors, the following actions are not supported:
#' 
#' - Replacement via `[<-` (throws an error).
#' - Subsetting by a character vector, as though subsetting by entry names.
#' - Subsetting by a logical vector.
#' @details
#' Subsetting via `[]` tries to delegate to native behaviour on numeric vectors
#' as quickly as possible by first
#' materializing the series as a vector, and then conducting the subsetting.
#' 
#' - If `i` is missing or has negative values, subsetting is delegated to the
#'   full series materialized via `get_discretes_in()` (if possible).
#' - If `i` is `NULL` or length-0, subsetting is delegated to a representative
#'   value of the series.
#' - If `i` doesn't have negative values, subsetting is delegated to the series
#'   materialized as far out as needed to cover all `i`s, via `next_discrete()`
#'   from `-Inf`.
#' @examples
#' natural1()[2]
#' natural1()[c(1, 3, 5)]
#' integers(1, 5)[-1]   # full series with first value dropped
#' 
#' # Subsetting from the other side of a sink
#' x <- 1 / natural1()
#' x[1:3]   # No such thing as a "first" value; returns NA.
#' y <- dsct_union(x, -1)
#' y[1:3]   # "-1" is the 1st value, but no such thing as 2nd or 3rd value.
#' @rdname subset_discretes
#' @export
`[.discretes` <- function(x, i) {
  if (missing(i)) {
    return(get_discretes_in(x)[i])
  }
  checkmate::assert_numeric(
    i,
    any.missing = TRUE,
    null.ok = TRUE
  )
  if (is.null(i) || length(i) == 0L || all(!is.finite(i))) {
    return(representative(x)[i])
  }
  if (any(i < 0, na.rm = TRUE)) {
    return(get_discretes_in(x)[i])
  }
  n_max <- ceiling(max(i[is.finite(i)]))
  y <- next_discrete(x, from = -Inf, n = n_max, include_from = TRUE)
  y[i]
}

#' @rdname subset_discretes
#' @export
`[<-.discretes` <- function(x, i, value) {
  stop(
    "Assignment via `[` is not supported for discretes; ",
    "use `dsct_keep()` or `dsct_drop()`."
  )
}
