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
#' `test_discretes(NA, NA)` evaluates to `NA`.
#' @export
test_discrete.numeric <- function(x,
                                  values,
                                  ...,
                                  tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  # 1. If the input is NA, we don't know if it's in the support
  if (any(is.na(x))) {
    return(rep(NA, length(values)))
  }

  # 2. If the support is empty, nothing can be in it (even an unknown)
  if (!length(x)) {
    return(rep(FALSE, length(values)))
  }

  # 3. Standard membership check (excluding NAs in the support itself)
  # Use match() or a loop with tolerance to avoid R's %in% behavior
  x <- unique(x)
  vapply(
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
}

