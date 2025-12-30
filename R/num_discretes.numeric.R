#' @export
num_discretes.numeric <- function(x,
                                  from,
                                  to,
                                  ...,
                                  include_from = TRUE,
                                  include_to = TRUE) {
  x <- unique(x)
  if (include_from) {
    left_query <- x >= from
  } else {
    left_query <- x > from
  }
  if (include_to) {
    right_query <- x <= to
  } else {
    right_query <- x < to
  }
  sum(left_query & right_query)
}
