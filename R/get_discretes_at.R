#' @param values Numeric vector of values to pull from the discrete set `x`.
#' @rdname get_discretes
#' @export
get_discretes_at <- function(x, values, ..., tol = sqrt(.Machine$double.eps)) {
  checkmate::assert_true(is_discrete_set(x))
  checkmate::assert_numeric(values, any.missing = TRUE)
  ellipsis::check_dots_empty()
  checkmate::assert_number(tol, lower = 0)
  has <- has_discretes(x, values = values, tol = tol)
  values <- values[which(is.na(values) | has)]
  type <- typeof(representative(x))
  values[!is.na(values)] <- vapply(
    values[!is.na(values)],
    function(v) next_discrete(x, v, include_from = TRUE, tol = tol),
    FUN.VALUE = vector(mode = type, length = 1L)
  )
  values
}