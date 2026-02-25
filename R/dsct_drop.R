#' @rdname subsetting
#' @export
dsct_drop <- function(x,
                      from = -Inf,
                      to = Inf,
                      ...,
                      include_from = TRUE,
                      include_to = TRUE) {
  nleft <- num_discretes(x, from = -Inf, to = from, include_to = !include_from)
  nright <- num_discretes(x, from = to, to = Inf, include_from = !include_to)
  ndropping <- num_discretes(
    x,
    from = from,
    to = to,
    include_from = include_from,
    include_to = include_to
  )
  if (ndropping == 0) {
    return(x)
  }
  type <- typeof(representative(x))
  if (nleft + nright == 0) {
    return(empty_set(type))
  }
  right_side <- dsct_keep(x, from = to, include_from = !include_to)
  if (nleft == 0) {
    return(right_side)
  }
  left_side <- dsct_keep(x, to = from, include_to = !include_from)
  if (nright == 0) {
    return(left_side)
  }
  dsct_union(left_side, right_side)
}
