test_that("exp() works on discretes", {
  x <- exp(integers())
  expect_true(all(test_discrete(x, values = c(exp(-1), 1, exp(1)))))
  expect_equal(next_discrete(x, from = 1.3, n = 3), exp(1:3))
})

test_that("log() works on positive discretes", {
  x <- 2^integers()
  y <- log(x)
  expect_equal(next_discrete(y, from = 0.1, n = 3), log(2) * (1:3))

  y2 <- log(x, base = 2)
  expect_equal(next_discrete(y2, from = 0.1, n = 3), 1:3)

  y3 <- natural0()
  expect_equal(
    next_discrete(y3, from = -Inf, include_from = TRUE, n = 3),
    log(0:2)
  )
})

test_that("log() errors on negative values", {
  expect_error(log(integers()))
  expect_error(log(dsct_union(-1, 1)))
})

test_that("log() supports base < 1", {
  a <- log(natural1(), base = 0.5)
  expect_equal(prev_discrete(a, from = 1, n = 3), log(1:3, base = 0.5))
})
