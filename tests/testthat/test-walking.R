test_that("next_discrete() - bad inputs", {
  x <- 1:10
  y <- natural1()
  expect_error(next_discrete(x, from = NA))
  expect_error(next_discrete(x, from = numeric()))
  expect_error(next_discrete(y, from = NA))
  expect_error(next_discrete(y, from = numeric()))
})

test_that("next_discrete() - edge cases", {
  x <- 1:10
  y <- natural1()
  z <- x + 0.5
  expect_identical(next_discrete(x, from = Inf), integer())
  expect_identical(next_discrete(x, from = 0, n = 0), integer())
  expect_identical(next_discrete(y, from = Inf), integer())
  expect_identical(next_discrete(y, from = 0, n = 0), integer())
  expect_identical(next_discrete(z, from = Inf), numeric())
  expect_identical(next_discrete(z, from = 0, n = 0), numeric())
  expect_error(next_discrete("hello", from = "hello"))
  expect_error(prev_discrete("hello", from = "hello"))
})

test_that("next_discrete() - numeric with NA", {
  x <- c(1:5, NA)
  # --> Able to resolve
  expect_identical(next_discrete(x, from = -7, n = 0), integer())
  expect_identical(next_discrete(x, from = 1, include_from = TRUE), 1L)

  # --> Not able to resolve
  expect_error(next_discrete(x, from = -0.2))
  expect_error(next_discrete(x, from = 3, n = 3, include_from = TRUE))
  expect_error(next_discrete(x, from = 3, n = 2, include_from = FALSE))
  expect_error(next_discrete(x, from = 3, n = 4, include_from = TRUE))
  expect_error(next_discrete(x, from = 3, n = 3, include_from = FALSE))
  expect_error(next_discrete(x, from = 2.6, n = 4, include_from = TRUE))
  expect_error(next_discrete(x, from = 2.6, n = 4, include_from = FALSE))
  expect_error(next_discrete(x, from = 2.6, n = Inf))
  # Double
  x <- c(1, 2, 3, 4, 5.5, NA_real_)
  # --> Able to resolve
  expect_identical(next_discrete(x, from = Inf), numeric())
  expect_identical(next_discrete(x, from = -7, n = 0), numeric())
  expect_identical(next_discrete(x, from = 3, n = 1, include_from = TRUE), 3)
  # --> Not able to resolve
  expect_error(next_discrete(x, from = 3, n = 1, include_from = FALSE))
  expect_error(next_discrete(x, from = 3, n = 2, include_from = TRUE))
  expect_error(next_discrete(x, from = 3, n = Inf, include_from = TRUE))
})

test_that("prev_discrete() - numeric with NA", {
  # Integers
  x <- c(1:5, NA)
  # --> Able to resolve
  expect_identical(prev_discrete(x, from = -7, n = 0), integer())
  expect_identical(prev_discrete(x, from = 1, include_from = TRUE), 1L)
  
  # --> Not able to resolve
  expect_error(prev_discrete(x, from = -0.2))
  expect_error(prev_discrete(x, from = 3, n = 3, include_from = TRUE))
  expect_error(prev_discrete(x, from = 3, n = 2, include_from = FALSE))
  expect_error(prev_discrete(x, from = 3, n = 4, include_from = TRUE))
  expect_error(prev_discrete(x, from = 3, n = 3, include_from = FALSE))
  expect_error(prev_discrete(x, from = 2.6, n = 4, include_from = TRUE))
  expect_error(prev_discrete(x, from = 2.6, n = 4, include_from = FALSE))
  expect_error(prev_discrete(x, from = 2.6, n = Inf))
  # Double
  x <- c(1, 2, 3, 4, 5.5, NA_real_)
  # --> Able to resolve
  expect_identical(prev_discrete(x, from = -Inf), numeric())
  expect_identical(prev_discrete(x, from = -7, n = 0), numeric())
  expect_identical(prev_discrete(x, from = 3, n = 1, include_from = TRUE), 3)
  # --> Not able to resolve
  expect_error(prev_discrete(x, from = 3, n = 1, include_from = FALSE))
  expect_error(prev_discrete(x, from = 3, n = 2, include_from = TRUE))
  expect_error(prev_discrete(x, from = 3, n = Inf, include_from = TRUE))
})
