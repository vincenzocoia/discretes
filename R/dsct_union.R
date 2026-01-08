#' Union of discrete series
#'
#' Combine one or more discrete series (or numeric vectors interpreted as
#' discrete support) into a single union that preserves the discrete traversal
#' contract. Duplicate support points are removed using a numerical tolerance.
#'
#' @param ... Objects to combine. Each must be either a `discretes` object or a
#'   numeric vector.
#' @param name Optional label used when printing the resulting series.
#' @returns A "discretes" object inheriting from `dsct_union`.
#' @examples
#' x1 <- natural1()
#' x2 <- -natural1()
#' dsct_union(x1, x2)
#' @export
dsct_union <- function(...) {
  inputs <- rlang::list2(...)
  good_inputs <- vapply(inputs, is_discretes, FUN.VALUE = logical(1L))
  if (!all(good_inputs)) {
    stop("All inputs must be discretes objects or numeric vectors.")
  }
  if (!length(inputs)) {
    return(numeric(0L))
  }
  res <- list()
  for (x in inputs) {
    if (inherits(x, "dsct_union")) {
      res <- append(res, x$inputs)
    }
    if (!is.null(x)) {
      res <- append(res, list(x))
    }
  }
  new_discretes(
    data = list(inputs = res),
    name = "Union",
    subclass = "dsct_union"
  )
}
