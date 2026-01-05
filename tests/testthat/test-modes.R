test_that("mode matches - representative() arithmetic()", {
  expect_type(representative(arithmetic(5L, 2)), "double")
  expect_type(representative(arithmetic(5, 2L)), "double")
  expect_type(representative(arithmetic(5L, 2L)), "integer")
  expect_type(representative(arithmetic(5L, 0L)), "integer")
  expect_type(
    representative(arithmetic(5L, 0L, n_left = 0, n_right = 0)),
    "integer"
  )
})

test_that("mode matches - representative() numeric()", {
  expect_type(representative(c(3.4, 2L, 5.6)), "double")
  expect_type(representative(c(1L, 2L, Inf)), "double")
  expect_type(representative(c(1L, 2L)), "integer")
  expect_type(representative(c(1L, NA, 2L)), "integer")
})

test_that("mode matches - representative() linear_transform()", {
  x <- arithmetic(5L, 2L)
  expect_type(representative(x * 3), "double")
  expect_type(representative(x * 3L), "integer")
  expect_type(representative(x + 3), "double")
  expect_type(representative(x + 3L), "integer")
  expect_type(representative(2L * x + 3), "double")
  expect_type(representative(2L * x + 3L), "integer")
  expect_type(representative(2 * x + 3), "double")
  expect_type(representative(2 * x + 3L), "double")
})

test_that("mode matches - representative() negation and inverse", {
  x <- arithmetic(5L, 2L)
  expect_type(representative(-x), "integer")
  expect_type(representative(-(-x)), "integer")
  expect_type(representative(1 / x), "double")
  expect_type(representative(1 / (1 / x)), "double")
  x <- arithmetic(2L, 0L)  # 2L / 2L still not an integer.
  expect_type(representative(2L / x), "double")
  expect_type(representative(x / 2L), "double")
})

test_that("mode matches - next_discrete() arithmetic()", {
  expect_type(
    next_discrete(arithmetic(5L, 2), from = 5L, include_from = TRUE),
    "double"
  )
  expect_type(
    next_discrete(arithmetic(5L, 2L), from = 5L, include_from = TRUE),
    "integer"
  )
  expect_type(next_discrete(arithmetic(5L, 2), from = 4.8), "double")
  expect_type(next_discrete(arithmetic(5L, 2L), from = 4.8), "integer")
  x <- arithmetic(5L, 0L)
  expect_type(next_discrete(x, from = 3), "integer")
  expect_type(next_discrete(x, from = 6), "integer")
  x <- arithmetic(5L, 100L, n_left = 0, n_right = 0)
  expect_type(next_discrete(x, from = 3), "integer")
  expect_type(next_discrete(x, from = 6), "integer")
  # Empty vectors:
  expect_type(next_discrete(arithmetic(5L, 2L), from = -Inf), "integer")
  expect_type(next_discrete(arithmetic(5L, 2L), from = Inf), "integer")
  expect_type(
    next_discrete(arithmetic(5L, 2L, n_left = 0), from = -Inf),
    "integer"
  )
  expect_type(
    next_discrete(arithmetic(5L, 2, n_left = 0), from = -Inf),
    "double"
  )
})

test_that("mode matches - prev_discrete() arithmetic()", {
  expect_type(
    prev_discrete(arithmetic(5L, 2), from = 5L, include_from = TRUE),
    "double"
  )
  expect_type(
    prev_discrete(arithmetic(5L, 2L), from = 5L, include_from = TRUE),
    "integer"
  )
  expect_type(prev_discrete(arithmetic(5L, 2), from = 5.8), "double")
  expect_type(prev_discrete(arithmetic(5L, 2L), from = 5.8), "integer")
  x <- arithmetic(5L, 0L)
  expect_type(prev_discrete(x, from = 3), "integer")
  expect_type(prev_discrete(x, from = 6), "integer")
  x <- arithmetic(5L, 100L, n_left = 0, n_right = 0)
  expect_type(prev_discrete(x, from = 3), "integer")
  expect_type(prev_discrete(x, from = 6), "integer")
  # Empty vectors:
  expect_type(prev_discrete(arithmetic(5L, 2L), from = -Inf), "integer")
  expect_type(prev_discrete(arithmetic(5L, 2L), from = Inf), "integer")
  expect_type(
    prev_discrete(arithmetic(5L, 2L, n_right = 0), from = Inf),
    "integer"
  )
  expect_type(
    prev_discrete(arithmetic(5L, 2, n_right = 0), from = Inf),
    "double"
  )
})
