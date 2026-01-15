#' @export
representative.dsct_keep <- function(x) {
  n <- num_discretes(x)
  if (n == 0) {
    return(numeric(0))
  }
  a <- next_discrete(x, from = x$left, n = 1L, include_from = x$include_left)
  if (length(a)) {
    return(a)
  }
  b <- prev_discrete(x, from = x$right, n = 1L, include_from = x$include_right)
  if (length(b)) {
    return(b)
  }
  sinks_matrix <- sinks(x)
  sinks12 <- sort(unique(sinks_matrix[, "location"]))[1:2]
  if (all(is.infinite(sinks12))) {
    mid <- 0
  } else if (is.infinite(sinks12[1])) {
    mid <- sinks12[2] - 1
  } else if (is.infinite(sinks12[2])) {
    mid <- sinks12[1] + 1
  } else {
    mid <- mean(sinks12)
  }
  a <- next_discrete(x, from = mid, n = 1L, include_from = TRUE)
  b <- prev_discrete(x, from = mid, n = 1L, include_from = TRUE)
  c(a, b)[1]
}
