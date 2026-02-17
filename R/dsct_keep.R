#' Subset a Discrete Value Series
#'
#' @inheritParams next_discrete
#' @param ... Reserved for future extensions; must be empty.
#' @param from,to Numeric values defining the range to keep; single numerics
#' with `from <= to`.
#' @param include_from,include_to Logical values indicating whether the
#' `from` and `to` values should be included in the kept range; single
#' logicals.
#' @return A `discretes` object representing the subset of discrete values
#'   within the specified range.
#' @examples
#' x <- integers(from = -3)
#' dsct_keep(x, from = -1.5, to = 2.5)
#' dsct_keep(x, to = 2)
#' @rdname subsetting
#' @export
dsct_keep <- function(x,
                      ...,
                      from = -Inf,
                      to = Inf,
                      include_from = TRUE,
                      include_to = TRUE) {
  ellipsis::check_dots_empty()
  checkmate::expect_number(from)
  checkmate::expect_number(to, lower = from)
  checkmate::expect_logical(include_from, len = 1, any.missing = FALSE)
  checkmate::expect_logical(include_to, len = 1, any.missing = FALSE)

  n_left <- num_discretes(x, to = from, include_to = !include_from)
  n_right <- num_discretes(x, from = to, include_from = !include_to)
  n_rm <- n_left + n_right
  if (!is.na(n_rm) && n_rm == 0L) {
    return(x)
  }
  n_remaining <- num_discretes(
    x,
    from = from,
    to = to,
    include_from = include_from,
    include_to = include_to
  )
  if (n_remaining == 0) {
    type <- typeof(representative(x))
    return(vector(type, length = 0L))
  }
  base_sinks <- sinks(x)
  location <- base_sinks[, "location"]
  direction <- base_sinks[, "direction"]
  sinks <- base_sinks[from <= location & to >= location, , drop = FALSE]
  new_discretes(
    data = list(
      base = x,
      left = from,
      right = to,
      include_left = include_from,
      include_right = include_to
    ),
    name = "Subset",
    sinks = sinks,
    subclass = "dsct_keep"
  )
}
