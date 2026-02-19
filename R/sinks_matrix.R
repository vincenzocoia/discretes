# Makes a sinks matrix from the given location and direction vectors with
# columns named "location" and "direction", per the arguments.
# - Arguments must be the same length.
# - Default is an empty matrix with 0 rows and 2 columns (i.e., no sinks).
# - `direction` can only be -1 (approached from left) or 1 (from right).
sinks_matrix <- function(location = numeric(0L), direction = numeric(0L)) {
  checkmate::assert_numeric(location)
  l <- length(location)
  checkmate::assert_numeric(direction, len = l)
  if (any(abs(direction) != 1)) {
    stop("direction must be 1 or -1.")
  }
  matrix(
    append(location, direction),
    ncol = 2,
    dimnames = list(NULL, c("location", "direction"))
  )
}