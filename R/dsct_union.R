#' Combine numeric series
#'
#' Combine one or more numeric series (or numeric vectors interpreted as
#' numeric series) into a single union, where each unique discrete value is
#' counted once.
#'
#' @param ... Objects to combine. Each must be either a numeric series or a
#'   numeric vector.
#' @returns A numeric series (inheriting from `dsct_union`).
#' @details
#' Values are flattened
#' @note While both `-0` and `+0` can both exist, 
#' @examples
#' x1 <- natural1()
#' x2 <- -natural1()
#' dsct_union(x1, x2)
#' @export
dsct_union <- function(...) {
  inputs <- rlang::list2(...)
  good_inputs <- vapply(inputs, is_series, FUN.VALUE = logical(1L))
  if (!all(good_inputs)) {
    stop("All inputs must be numeric series or numeric vectors.")
  }
  res <- list()
  for (x in inputs) {
    if (inherits(x, "dsct_union")) {
      res <- append(res, x$inputs)
    } else if (!is.null(x) && !identical(num_discretes(x), 0L)) {
      res <- append(res, list(x))
    }
  }
  if (!length(res)) {
    return(empty_series())
  }
  if (length(res) == 1) {
    return(res[[1]])
  }
  sinks_list <- lapply(res, sinks)
  sinks <- do.call(rbind, sinks_list)
  sinks <- unique(sinks)
  new_discretes(
    data = list(inputs = res),
    name = "Union",
    sinks = sinks,
    subclass = "dsct_union"
  )
}
