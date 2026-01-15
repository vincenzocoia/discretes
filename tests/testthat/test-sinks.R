make_expected_sinks <- function(location = numeric(), direction = numeric()) {
  if (!length(location)) {
    return(
      matrix(numeric(0), ncol = 2, dimnames = list(NULL, c("location", "direction")))
    )
  }
  sinks <- cbind(location = as.numeric(location), direction = as.numeric(direction))
  sinks <- unique(sinks)
  sinks[order(sinks[, "location"], sinks[, "direction"]), , drop = FALSE]
}

expect_sinks <- function(x, location = numeric(), direction = numeric()) {
  expected <- make_expected_sinks(location = location, direction = direction)
  actual <- attr(x, "sinks")
  testthat::expect_equal(actual, expected)
}

test_that("sinks - arithmetic and integers", {
  x <- arithmetic(representative = 0, spacing = 1)
  expect_sinks(x, location = c(-Inf, Inf), direction = c(1, -1))

  y <- integers()
  expect_sinks(y, location = c(-Inf, Inf), direction = c(1, -1))
})

test_that("sinks - transformations", {
  x <- dsct_invert(natural1())
  expect_sinks(x, location = 0, direction = 1)

  y <- dsct_transform(integers(), fun = exp, inv = log)
  expect_sinks(y, location = c(0, Inf), direction = c(1, -1))

  z <- dsct_negate(natural1())
  expect_sinks(z, location = -Inf, direction = 1)
})

test_that("sinks - linear transform and keep", {
  x <- dsct_linear(integers(), m = 2, b = 1)
  expect_sinks(x, location = c(-Inf, Inf), direction = c(1, -1))

  y <- dsct_invert(natural1())
  y_keep <- dsct_keep(y, from = 0, include_from = FALSE)
  expect_sinks(y_keep, location = 0, direction = 1)

  y_drop <- dsct_keep(y, to = 0)
  expect_sinks(y_drop)
})

test_that("sinks - union", {
  x <- dsct_union(natural1(), dsct_negate(natural1()))
  expect_sinks(x, location = c(-Inf, Inf), direction = c(1, -1))
})
