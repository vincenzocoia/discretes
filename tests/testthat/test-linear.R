test_that("dsct_linear returns a dsct_transform subclass with m/b fields", {
  base <- integers()
  x <- discretes:::dsct_linear(base, m = 2L, b = NULL)

  expect_true(inherits(x, "dsct_linear"))
  expect_true(inherits(x, "dsct_transform"))
  expect_true(inherits(x, "discretes"))

  expect_identical(x[["m"]], 2L)
  expect_true(is.null(x[["b"]]))
  expect_identical(x[["base"]], base)
  expect_identical(typeof_dsct(x), "integer")
})

test_that("dsct_linear composition preserves b = NULL semantics", {
  base <- integers()

  # Original linear transform with b = NULL.
  x <- discretes:::dsct_linear(base, m = 2L, b = NULL)
  y <- discretes:::dsct_linear(x, m = 3L, b = NULL)
  expect_identical(y[["m"]], 6L)
  expect_true(is.null(y[["b"]]))

  z <- discretes:::dsct_linear(x, m = 3L, b = 0)
  expect_identical(z[["m"]], 6L)
  expect_identical(z[["b"]], 0)
  expect_identical(typeof(representative(z)), "double")

  # Original linear transform with b not NULL.
  x <- discretes:::dsct_linear(base, m = 2L, b = 1L)
  y <- discretes:::dsct_linear(x, m = 3L, b = NULL)
  expect_identical(y[["m"]], 6L)
  expect_identical(y[["b"]], 3L)

  z <- discretes:::dsct_linear(x, m = 3L, b = 2L)
  expect_identical(z[["m"]], 6L)
  expect_identical(z[["b"]], 5L)
})

test_that("b = NULL vs b = 0 differs for signed zero", {
  neg0 <- arithmetic(-0, 1, n_left = 0, n_right = 0)

  # Multiplication alone should preserve -0.
  t1 <- 2 * neg0
  expect_identical(has_negative_zero(t1), TRUE)
  expect_identical(has_positive_zero(t1), FALSE)

  # Explicit +0 should behave like numeric: it removes negative zero.
  t2 <- t1 + 0
  expect_identical(has_negative_zero(t2), FALSE)
  expect_identical(has_positive_zero(t2), TRUE)

  # Negative multiplication
  t3 <- -2 * neg0
  expect_identical(has_negative_zero(t3), FALSE)
  expect_identical(has_positive_zero(t3), TRUE)

  # Both
  t4 <- 2 * dsct_union(neg0, 0)
  expect_identical(has_negative_zero(t4), TRUE)
  expect_identical(has_positive_zero(t4), TRUE)

  # Both, but adding 0 eliminates them.
  t5 <- 2 * dsct_union(neg0, 0) + 0
  expect_identical(has_negative_zero(t5), FALSE)
  expect_identical(has_positive_zero(t5), TRUE)

  # Both, but subtracting 0 preserves them.
  t5 <- 2 * dsct_union(neg0, 0) - 0
  expect_identical(has_negative_zero(t5), TRUE)
  expect_identical(has_positive_zero(t5), TRUE)
})

test_that("dsct_linear.dsct_linear preserves signed zero in intercept", {
  base <- integers()

  # Start with an explicit negative-zero intercept.
  x <- discretes:::dsct_linear(base, m = 1, b = -0)
  expect_false(is.null(x[["b"]]))
  expect_identical(has_negative_zero(x[["b"]]), TRUE)
  expect_identical(has_positive_zero(x[["b"]]), FALSE)
  expect_identical(has_negative_zero(x), FALSE)
  expect_identical(has_positive_zero(x), TRUE)

  # Composing with b=NULL should not add +0, so -0 stays -0.
  y <- discretes:::dsct_linear(x, m = 2, b = NULL)
  expect_false(is.null(y[["b"]]))
  expect_identical(has_negative_zero(y[["b"]]), TRUE)
  expect_identical(has_positive_zero(y[["b"]]), FALSE)
  expect_identical(has_negative_zero(y), FALSE)
  expect_identical(has_positive_zero(y), TRUE)

  # Composing with explicit +0 should behave like numeric arithmetic:
  # (-0) * 2 + (+0) becomes +0
  z <- discretes:::dsct_linear(x, m = 2, b = 0)
  expect_false(is.null(z[["b"]]))
  expect_identical(has_negative_zero(z[["b"]]), FALSE)
  expect_identical(has_positive_zero(z[["b"]]), TRUE)
  expect_identical(has_negative_zero(z), FALSE)
  expect_identical(has_positive_zero(z), TRUE)
})

test_that("Ops results in proper linear transform.", {
  # Check that x and y are the same linear transform.
  # x and y must be "dsct_linear" objects.
  # Run for its 'expect_*()' side effects.
  expect_same_linear <- function(x, y) {
    testthat::expect_true(inherits(x, "dsct_linear"))
    testthat::expect_true(inherits(y, "dsct_linear"))
    testthat::expect_identical(x[["m"]], y[["m"]])
    testthat::expect_identical(x[["b"]], y[["b"]])
    testthat::expect_identical(x[["base"]], y[["base"]])
    testthat::expect_identical(
      typeof_dsct(x),
      typeof(representative(y))
    )
    testthat::expect_identical(
      has_negative_zero(x),
      has_negative_zero(y)
    )
    testthat::expect_identical(
      has_positive_zero(x),
      has_positive_zero(y)
    )
    invisible()
  }
  
  # Differently compound linear transforms
  base <- natural0()
  x <- discretes:::dsct_linear(base, m = 2, b = NULL)
  expect_same_linear(2 * base, x)
  y <- discretes:::dsct_linear(base, m = 3, b = 6)
  expect_same_linear(3 * base + 6, y)
  expect_same_linear(6 + 3 * base, y)
  expect_same_linear(3 * (base + 2), y)
  expect_same_linear(6 * (base / 2 + 2) - 6, y)
  expect_same_linear(base / (1 / 3) + 6, y)
  z <- discretes:::dsct_linear(base, m = 2, b = 0)
  expect_same_linear(2 * base + 5 - 5, z)
})

test_that("dsct_linear edge cases", {
  expect_error(1:2 * integers())
  expect_error(1:2 * integers() + 5)
  expect_error(integers() + 1:2)
  expect_error(2 * integers() + 1:2)
})