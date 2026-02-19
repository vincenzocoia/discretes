test_that("+0 and -0 combined takes first instance.", {
  expect_equal(1 / get_discretes_in(dsct_union(0, -0)), Inf)
  expect_equal(1 / get_discretes_in(dsct_union(-0, 0)), -Inf)
  xboth1 <- dsct_union(arithmetic(-0, 1), arithmetic(0, 1))
  expect_equal(1 / get_discretes_in(xboth1, from = 0, to = 0), -Inf)
  xboth2 <- dsct_union(arithmetic(0, 1), arithmetic(-0, 1))
  expect_equal(1 / get_discretes_in(xboth2, from = 0, to = 0), Inf)
  # While a series containing only -0 and +0 has only one value,
  # the inverse of this series will have two: -Inf and Inf. This is because
  # all components of the discrete series remains intact until expression
  # as a vector via `get_discretes_in()`.
  expect_equal(get_discretes_in(1 / dsct_union(0, -0)), c(Inf, -Inf))
  
})


test_that("dsct_union merges symmetric discrete series", {
  x <- dsct_union(natural1(), -natural1())
  expect_s3_class(x, "discretes")
  expect_identical(
    next_discrete(x, from = -2.5, n = 5L),
    c(-2L, -1L, 1L, 2L, 3L)
  )
  expect_identical(
    prev_discrete(x, from = 2.5, n = 5L),
    c(2L, 1L, -1L, -2L, -3L)
  )
  expect_identical(num_discretes(x, from = -3, to = 3), 6L)
  expect_false(has_discretes(x, values = 0))
})

test_that("dsct_union recognises duplicates and numeric support", {
  x <- dsct_union(c(-2, 0, 2, 2), natural1())
  expect_identical(
    get_discretes_in(x, from = -2, to = 3),
    c(-2, 0, 1, 2, 3)
  )
  expect_true(all(has_discretes(x, values = c(-2, 0, 1))))
  expect_false(has_discretes(x, values = -3))
})

test_that("dsct_union detects infinite support", {
  x <- dsct_union(natural1(), c(-5, -4))
  expect_true(has_infinite_discretes(x))
})

test_that("dsct_union has_discretes follows union semantics with NA inputs", {
  x <- dsct_union(c(NA, 1), natural1())
  expect_identical(
    has_discretes(x, values = c(1, 2, NA)),
    c(TRUE, TRUE, NA)
  )
})

test_that("dsct_union representative draws from combined support", {
  x <- dsct_union(natural1(), -natural1())
  expect_true(has_discretes(x, values = representative(x)))
  y <- dsct_union(c(-4, -2), 5)
  expect_true(representative(y) %in% c(-4, -2, 5))
})
