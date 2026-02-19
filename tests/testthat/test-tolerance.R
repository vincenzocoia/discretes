test_that("zero tolerance for integers is meaningful - next_discrete()", {
  # Numeric
  x <- c(4L, 1L, -5L, 9L)
  expect_equal(
    next_discrete(x, from = 1L, n = Inf, include_from = TRUE, tol = 0),
    c(1L, 4L, 9L)
  )
  expect_equal(
    next_discrete(x, from = 1L, n = Inf, include_from = FALSE, tol = 0),
    c(4L, 9L)
  )
  # Discretes
  x <- integers(-2, 4)
  expect_equal(
    next_discrete(x, from = 1L, n = Inf, include_from = TRUE, tol = 0),
    c(1L, 2L, 3L, 4L)
  )
  expect_equal(
    next_discrete(x, from = 1L, n = Inf, include_from = FALSE, tol = 0),
    c(2L, 3L, 4L)
  )
})

test_that("zero tolerance for integers is meaningful - prev_discrete()", {
  # Numeric
  x <- c(4L, 1L, -5L, 9L)
  expect_equal(
    prev_discrete(x, from = 1L, n = Inf, include_from = TRUE, tol = 0),
    c(1L, -5L)
  )
  expect_equal(
    prev_discrete(x, from = 1L, n = Inf, include_from = FALSE, tol = 0),
    -5L
  )
  # Discretes
  x <- integers(-2, 4)
  expect_equal(
    prev_discrete(x, from = 1L, n = Inf, include_from = TRUE, tol = 0),
    c(1L, 0L, -1L, -2L)
  )
  expect_equal(
    prev_discrete(x, from = 1L, n = Inf, include_from = FALSE, tol = 0),
    c(0L, -1L, -2L)
  )
})

