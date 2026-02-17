#' @export
dsct_transform.numeric <- function(x,
                                   fun,
                                   inv,
                                   domain = c(-Inf, Inf),
                                   range = c(-Inf, Inf)) {
  checkmate::assert_function(fun)
  checkmate::assert_function(inv)
  checkmate::assert_numeric(domain, len = 2, any.missing = FALSE)
  checkmate::assert_numeric(range, len = 2, any.missing = FALSE)
  checkmate::assert_number(domain[2], lower = domain[1])
  checkmate::assert_number(range[2], lower = range[1])
  validate_transform_fun(fun, inv, domain = domain, range = range)
  fun(x)
}
