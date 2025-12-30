#' @export
num_discretes.inverse <- function(x,
                                  from,
                                  to,
                                  ...,
                                  include_from = TRUE,
                                  include_to = TRUE) {
  d_nested <- distribution$distribution
  if (to < from) {
    a <- to
    b <- from
    include_a <- include_to
    include_b <- include_from
  } else {
    a <- from
    b <- to
    include_a <- include_from
    include_b <- include_to
  }
  if (b <= 0) {
    n <- distionary::num_discretes(
      d_nested, from = -1 / abs(b), to = -1 / abs(a),
      include_from = include_b, include_to = include_a
    )
  } else if (a >= 0) {
    n <- distionary::num_discretes(
      d_nested, from = 1 / b, to = 1 / a, include_from = include_b,
      include_to = include_a
    )
  } else {
    n_neg <- distionary::num_discretes(
      d_nested, from = -Inf, to = 1 / a, include_from = FALSE,
      include_to = include_a
    )
    n_pos <- distionary::num_discretes(
      d_nested, from = 1 / b, to = Inf, include_from = include_b,
      include_to = FALSE
    )
    n <- n_neg + n_pos
  }
  n
}
