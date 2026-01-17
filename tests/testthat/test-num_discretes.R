test_that("regular num_discretes() behaviour", {
  # Numeric
  x <- c(6.5, 6, 7.2, 7.2, 7.2, 8.1, 9.9, 10)
  expect_identical(num_discretes(x, from = 6, to = 8), 3L)
  expect_identical(num_discretes(x, from = 6, to = 8, include_from = FALSE), 2L)
  expect_identical(num_discretes(x), 6L)
  # Arithmetic
  x <- integers()
  expect_identical(num_discretes(x), Inf)
  expect_identical(num_discretes(x, from = 1, to = 9), 9L)
  expect_identical(num_discretes(x, from = 1, to = 9, include_from = FALSE), 8L)
  expect_identical(num_discretes(x, from = 1, to = 9, include_to = FALSE), 8L)
  expect_identical(
    num_discretes(x, from = 1, to = 9,include_from = FALSE, include_to = FALSE),
    7L
  )
  expect_identical(num_discretes(natural0()), Inf)
  expect_identical(num_discretes(integers(to = 0)), Inf)
  # Reciprocal
  x <- 1 / natural1()
  expect_identical(num_discretes(x), Inf)
  x <- dsct_keep(1 / natural1(), from = 0.01)
  expect_identical(num_discretes(x), 100L)
})

test_that("num_discretes() behaviour around numeric vectors with NA", {
  # Numeric
  x <- c(NA, 6.5, 6, Inf, -Inf)
  expect_identical(
    num_discretes(x, from = 6, to = 6, include_from = TRUE, include_to = TRUE),
    1L
  )
  expect_identical(
    num_discretes(
      x, from = 6.2, to = 6.2, include_from = TRUE, include_to = TRUE
    ),
    NA_integer_
  )
  expect_identical(num_discretes(x, from = Inf), 1L)
  expect_identical(num_discretes(x, to = -Inf), 1L)
  expect_identical(num_discretes(x, from = Inf, include_from = FALSE), 0L)
  expect_identical(num_discretes(x, to = -Inf, include_to = FALSE), 0L)
  expect_identical(
    num_discretes(
      x, from = 6, to = 6.5, include_from = TRUE, include_to = TRUE
    ),
    NA_integer_
  )
  expect_identical(
    num_discretes(
      x, from = 60, to = 65, include_from = TRUE, include_to = TRUE
    ),
    NA_integer_
  )
  # Integer
  x <- c(NA, 7L, 6L, 8L)
  expect_identical(
    num_discretes(
      x, from = 6L, to = 7L, include_from = TRUE, include_to = TRUE
    ),
    2L
  )
  expect_identical(
    num_discretes(
      x, from = 6L, to = 7L, include_from = TRUE, include_to = FALSE
    ),
    1L
  )
  expect_identical(
    num_discretes(
      x, from = 6L, to = 7L, include_from = FALSE, include_to = TRUE
    ),
    1L
  )
  expect_identical(
    num_discretes(
      x, from = 6L, to = 7L, include_from = FALSE, include_to = FALSE
    ),
    0L
  )
})


test_that("num_discretes() behaviour with from = to", {
  # from = to = Finite value
  x <- c(6.5, 6)
  expect_identical(
    num_discretes(x, from = 7, to = 7, include_from = TRUE, include_to = TRUE),
    0L
  )
  expect_identical(
    num_discretes(x, from = 6, to = 6, include_from = TRUE, include_to = TRUE),
    1L
  )
  expect_identical(
    num_discretes(x, from = 6, to = 6, include_from = TRUE, include_to = FALSE),
    0L
  )
  expect_identical(
    num_discretes(x, from = 6, to = 6, include_from = FALSE, include_to = TRUE),
    0L
  )
  expect_identical(
    num_discretes(
      x, from = 6, to = 6, include_from = FALSE, include_to = FALSE
    ),
    0L
  )
  # from = to = Inf
  x <- c(6, Inf)
  expect_identical(
    num_discretes(
      x, from = Inf, to = Inf, include_from = TRUE, include_to = TRUE
    ),
    1L
  )
  expect_identical(
    num_discretes(
      x, from = Inf, to = Inf, include_from = TRUE, include_to = FALSE
    ),
    0L
  )
  expect_identical(
    num_discretes(
      x, from = Inf, to = Inf, include_from = FALSE, include_to = TRUE
    ),
    0L
  )
  expect_identical(
    num_discretes(
      x, from = Inf, to = Inf, include_from = FALSE, include_to = FALSE
    ),
    0L
  )
  expect_identical(
    num_discretes(
      c(6, 9), from = Inf, to = Inf, include_from = TRUE, include_to = TRUE
    ),
    0L
  )
  # from = to = -Inf
  x <- c(6, -Inf)
  expect_identical(
    num_discretes(
      x, from = -Inf, to = -Inf, include_from = TRUE, include_to = TRUE
    ),
    1L
  )
  expect_identical(
    num_discretes(
      x, from = -Inf, to = -Inf, include_from = TRUE, include_to = FALSE
    ),
    0L
  )
  expect_identical(
    num_discretes(
      x, from = -Inf, to = -Inf, include_from = FALSE, include_to = TRUE
    ),
    0L
  )
  expect_identical(
    num_discretes(
      x, from = -Inf, to = -Inf, include_from = FALSE, include_to = FALSE
    ),
    0L
  )
  expect_identical(
    num_discretes(
      c(6, 9), from = -Inf, to = -Inf, include_from = TRUE, include_to = TRUE
    ),
    0L
  )
})
