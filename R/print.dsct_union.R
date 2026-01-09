#' @export
print.dsct_union <- function(x, ...) {
  l <- length(x$inputs)
  cat("Union of ", l, "series:\n")
  for (i in utils::head(seq_along(x$inputs), 5)) {
    cat(i, ". ", sep = "")
    print(x$inputs[[i]], ...)
  }
  if (l > 5) {
    cat("[and ", l - 5, " more series.]\n", sep = "")
  }
  invisible(x)
}
