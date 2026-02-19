#' Test membership of values against a vector
#'
#' This function is like `values %in% x`, testing whether each element of
#' `values` can be found in `x`, except is more strict about handling
#' `NA` values, which are interpreted as missing data. See details.
#' @details
#' `NA` values are treated as missing data, so that if `x` contains `NA`,
#' it is impossible to know whether any value of `values` belongs to `x`,
#' and therefore the result is `NA` for all elements of `values`.
#' Similarly, if any element of `values` is `NA`, the result for that
#' element is `NA`, except when `x` is the empty set (`numeric(0L)`),
#' in which case we can confidently say that, whatever the missing value is,
#' it cannot belong to `x`, and so the result is `FALSE`.
#'
#' This is unlike Base R, which treats `NA` as a distinct element of a set.
#' As a result, `NA %in% NA` evaluates to `TRUE`, whereas
#' `has_discretess(NA, NA)` evaluates to `NA`.
#' @noRd
#' @export
has_discretes.numeric <- function(x,
                                  values,
                                  ...,
                                  tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  has_na <- any(is.na(x))
  if (!length(x)) {
    return(rep(FALSE, length(values)))
  }
  x <- unique(x)
  x <- x[!is.na(x)]
  res <- vapply(
    values,
    FUN = function(v) {
      if (is.infinite(v)) {
        return(v %in% x)
      }
      if (is.na(v)) {
        return(NA)
      }
      any(abs(v - x) < tol)
    },
    FUN.VALUE = logical(1L)
  )
  if (has_na) {
    # Can't say FALSE when NAs are present, but we can say what's TRUE.
    res[!res] <- NA
  }
  res
}

