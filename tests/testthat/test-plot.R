test_that("plot.discretes runs without error", {
  pdf(NULL)
  on.exit(dev.off())
  expect_silent(plot(integers(), from = -5, to = 5))
})

test_that("plot.discretes returns input invisibly", {
  pdf(NULL)
  on.exit(dev.off())
  x <- integers()
  out <- plot(x, from = -3, to = 3)
  expect_identical(out, x)
  expect_false(withVisible(plot(x, from = -2, to = 2))$visible)
})

test_that("plot.discretes with finite series", {
  pdf(NULL)
  on.exit(dev.off())
  x <- as_discretes(seq(-2, 2, by = 0.5))
  expect_silent(plot(x))
})

test_that("plot.discretes with sink at finite value", {
  pdf(NULL)
  on.exit(dev.off())
  x <- 0.5^natural0()
  expect_silent(plot(x, from = 0, to = 1, closeness = 1e-3))
})

test_that("plot.discretes with union (multiple sinks)", {
  pdf(NULL)
  on.exit(dev.off())
  x <- dsct_union(0.5^natural1(), 0)
  expect_silent(plot(x, from = -0.5, to = 1.5, closeness = 1e-3))
})
