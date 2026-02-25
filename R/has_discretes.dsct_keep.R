#' @export
has_discretes.dsct_keep <- function(x,
                                    values,
                                    ...,
                                    tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_numeric(values, any.missing = TRUE, finite = FALSE)
  checkmate::assert_number(tol, lower = 0)
  inside <- is_between(
    values,
    lower = x[["left"]],
    upper = x[["right"]],
    include_lower = x[["include_left"]],
    include_upper = x[["include_right"]]
  )
  inside & has_discretes(
    x[["base"]],
    values = values,
    tol = tol,
    ...
  )
}
