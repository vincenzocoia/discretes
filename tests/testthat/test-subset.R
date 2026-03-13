test_that("[.discretes - natural1()", {
  expect_identical(natural1()[1], 1L)
  expect_identical(natural1()[2], 2L)
  expect_identical(natural1()[c(1, 3, 5)], c(1L, 3L, 5L))
  expect_identical(natural1()[1:4], 1:4)
  expect_identical(natural1()[4.8], 4L)
})

test_that("[.discretes - transformed series", {
  # Arithmetic transform has a clear first element (2*natural1() is double)
  x <- 2 * natural1()
  expect_identical(x[1], 2)
  expect_identical(x[1:3], c(2, 4, 6))
})

test_that("[.discretes - edge case indices", {
  expect_identical(natural1()[integer()], integer())
  expect_identical(natural1()[NULL], integer())
  expect_identical(natural1()[0], integer())
  expect_error(natural1()[])
  expect_identical(as_discretes(1:10)[], 1:10)
  expect_identical(natural1()[c(1:10, NA_integer_)], c(1:10, NA_integer_))
  expect_identical(natural1()[c(0:10)], 1:10)
  expect_identical(integers()[c(NA, Inf)], (1L)[c(NA, Inf)])
  expect_identical(integers()[NA], NA_integer_)
  expect_identical(natural1()[c(2, NA, Inf)], c(2L, NA_integer_, NA_integer_))
})

test_that("[.discretes - no first element gives NA", {
  # integers() is unbounded on the left; base R returns NA
  expect_identical(integers()[1], NA_integer_)
  # Try with a sink at 0 from the right.
  x <- dsct_union(-1, 1 / natural1())
  expect_identical(x[1:3], c(-1, NA, NA))
})

test_that("[.discretes - negative index (drop)", {
  # Negative i: full series with those positions dropped. Finite series only.
  expect_identical(integers(1, 5)[-1], 2:5)
  expect_identical(integers(1, 5)[-2], c(1L, 3L, 4L, 5L))
  # Infinite series: get_discretes_in() errors
  expect_error(natural1()[-1])
  # Mixed positive and negative: base R errors (use finite series so we hit that)
  expect_error(integers(1, 5)[c(1, -2)])
})

test_that("[<-.discretes - assignment errors", {
  foo <- natural1()
  expect_error(foo[1] <- -5L)
})
