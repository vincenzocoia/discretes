test_that("Bad function inputs to dsct_transform() result in warning", {
  expect_a_warning <- function(expr) {
    suppressWarnings(expect_warning(expr))
  }
  # Not proper inverse
  expect_a_warning(dsct_transform(integers(), fun = exp, inv = exp))
  expect_a_warning(dsct_transform(-100:100, fun = exp, inv = exp))
  # Not increasing
  expect_a_warning(dsct_transform(integers(), fun = `-`, inv = `-`))
  # Improper domain -> range mapping
  expect_a_warning(
    dsct_transform(
      integers(),
      fun = exp,
      inv = log,
      domain = c(0, 10),
      range = c(-100, 0)
    )
  )
  # Not vectorized
  expect_a_warning(
    dsct_transform(
      integers(),
      fun = function(x) exp(x[1]),
      inv = log,
      range = c(0, Inf)
    )
  )
  expect_a_warning(
    dsct_transform(
      integers(),
      fun = exp,
      inv = function(x) log(x[1]),
      range = c(0, Inf)
    )
  )
  # Function evaluates to NA
  expect_a_warning(
    dsct_transform(
      integers(),
      fun = function(x) {
        y <- exp(x)
        y[x == 0] <- NA
        y
      },
      log,
      domain = 0:1,
      range = c(1, exp(1))
    )
  )
  # Trying to map values outside of the domain
  expect_a_warning(
    dsct_transform(
      integers(),
      fun = exp,
      inv = log,
      domain = c(0, 10),
      range = c(1, exp(10))
    )
  )
  # Trying to map values outside of the range
  y <- dsct_transform(
    integers(),
    fun = exp,
    inv = log,
    range = c(0, 100)
  )
  expect_a_warning(next_discrete(y, from = 50, n = 2))
})

test_that("Identity transform works", {
  x <- integers()
  y <- dsct_transform(x, fun = identity, inv = identity)
  expect_equal(
    next_discrete(y, from = 0, n = 10),
    next_discrete(x, from = 0, n = 10)
  )
  expect_equal(
    prev_discrete(y, from = 0, n = 10),
    prev_discrete(x, from = 0, n = 10)
  )
  expect_equal(
    num_discretes(y, from = -10, to = 10),
    num_discretes(x, from = -10, to = 10)
  )
  expect_equal(representative(x), representative(y))
  expect_equal(
    test_discrete(x, values = c(3, 4.5, -10, 100)),
    test_discrete(y, values = c(3, 4.5, -10, 100))
  )
})


test_that("Empty sets remain empty", {
  x <- dsct_empty()
  y <- dsct_transform(x, exp, log, range = c(0, Inf))
  expect_identical(x, y)
  x <- dsct_empty("integer")
  y <- dsct_transform(x, exp, log, range = c(0, Inf))
  expect_identical(typeof(representative(y)), "double")
})


test_that("dsct_transform() works with custom domain and range.", {
  x <- integers()
  # R -> (0, 1)
  y <- dsct_transform(x, pnorm, qnorm, range = c(0, 1))
  expect_equal(
    next_discrete(y, from = 0.5001, n = 4),
    pnorm(1:4)
  )
  expect_equal(
    prev_discrete(y, from = 0.5001, n = 4),
    pnorm(0:-3)
  )
  # Transforming numeric results in numeric.
  y <- dsct_transform(
    c(3, 0, 2),
    fun = function(t) -cos(t),
    inv = function(t) acos(-t),
    domain = c(0, pi),
    range = c(-1, 1)
  )
  expect_equal(y, -cos(c(3, 0, 2)))
  # Transforming from a finite domain to finite range.
  x <- seq(0, pi, length.out = 10)
  y <- dsct_transform(
    dsct_numeric(x),
    fun = function(t) -cos(t),
    inv = function(t) acos(-t),
    domain = c(0, pi),
    range = c(-1, 1)
  )
  expect_true(test_discrete(y, values = representative(y)))
  expect_equal(num_discretes(y), 10)
  expect_equal(num_discretes(y, to = -1.1), 0)
  expect_equal(num_discretes(y, from = 1.1), 0)
  expect_equal(
    prev_discrete(y, from = Inf, n = 4, include_from = FALSE),
    prev_discrete(y, from = pi, n = 4, include_from = TRUE)
  )
  expect_identical(
    prev_discrete(y, from = -4, n = 4),
    numeric()
  )
  expect_equal(
    prev_discrete(y, from = -1, n = 4, include_from = TRUE),
    -1
  )
  expect_equal(num_discretes(y, to = 0), 5)
  expect_equal(num_discretes(y, from = 0), 5)
  expect_equal(
    test_discrete(y, values = c(-cos(c(0, pi)), 0)),
    c(TRUE, TRUE, FALSE)
  )
  # Mode is preserved
  y <- dsct_transform(integers(), identity, identity)
  expect_equal(typeof(representative(y)), "integer")
  y <- dsct_transform(integers(), exp, log, range = c(0, Inf))
  expect_equal(typeof(representative(y)), "double")
  # Zeroes preserved with identity
  y <- dsct_transform(dsct_union(0, -0), identity, identity)
  expect_true(has_negative_zero(y))
  expect_true(has_positive_zero(y))
  y <- dsct_transform(dsct_union(0, -0), function(x) x + 0, identity)
  expect_false(has_negative_zero(y))
  expect_true(has_positive_zero(y))
})