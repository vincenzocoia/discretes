test_that("range/min/max use extreme discrete values, not internals", {
  # Regression: range(natural1()) used to fall through to range.default,
  # which flattened the internal list and returned c(0, Inf).
  expect_equal(range(natural1()), c(1, Inf))
  expect_equal(min(natural1()), 1)
  expect_equal(max(natural1()), Inf)

  expect_equal(range(natural0()), c(0, Inf))
  expect_equal(range(integers(5, 10)), c(5, 10))
  expect_equal(range(integers(-3, 3)), c(-3, 3))
  expect_equal(range(integers()), c(-Inf, Inf))
  expect_equal(range(2 * natural1()), c(2, Inf))
})

test_that("range accounts for sinks (limit points)", {
  # 1 / natural1() = {1, 1/2, 1/3, ...} piles up against a sink at 0.
  expect_equal(range(1 / natural1()), c(0, 1))
  expect_equal(min(1 / natural1()), 0)
  expect_equal(max(1 / natural1()), 1)
  expect_equal(range(-1 / natural1()), c(-1, 0))
  expect_equal(range(1 / integers()), c(-1, Inf))
  expect_equal(range(0.5^natural0()), c(0, 1))
})

test_that("range/min/max combine series with bare numerics", {
  expect_equal(min(natural1(), -5), -5)
  expect_equal(max(integers(5, 10), 100), 100)
  expect_equal(range(integers(5, 10), 100), c(5, 100))
})

test_that("empty series matches base R empty-range behaviour", {
  # range() on an empty series warns once for min and once for max.
  expect_warning(expect_warning(range(empty_series())))
  expect_equal(suppressWarnings(range(empty_series())), c(Inf, -Inf))
})

test_that("sum/prod work on finite series and error on infinite ones", {
  expect_equal(sum(integers(1, 100)), 5050)
  expect_equal(prod(integers(1, 5)), 120)
  expect_error(sum(natural1()), "infinitely many")
  expect_error(prod(integers()), "infinitely many")
})

test_that("all/any are not defined for numeric series", {
  expect_error(all(natural1()), "not defined")
  expect_error(any(natural1()), "not defined")
})
