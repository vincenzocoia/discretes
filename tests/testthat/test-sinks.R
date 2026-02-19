expect_sinks <- function(x, location, direction) {
  a <- sinks(x)
  a <- a[order(a[, "location"], a[, "direction"]), , drop = FALSE]
  b <- sinks_matrix(location, direction)
  b <- b[order(b[, "location"], b[, "direction"]), , drop = FALSE]
  expect_identical(a, b)
}

test_that("sinks - arithmetic and integers", {
  # Sinks at infinity
  x <- arithmetic(0, 1)
  expect_sinks(x, c(-Inf, Inf), c(1, -1))
  expect_true(has_sink(x))
  expect_false(has_sink(x, -10, 10))
  
  y <- integers()
  expect_sinks(y, c(-Inf, Inf), c(1, -1))
  expect_true(has_sink(y))
  expect_false(has_sink(y, -10, 10))
  
  z <- natural1()
  expect_sinks(z, Inf, -1)
  expect_true(has_sink(z))
  expect_false(has_sink(z, to = 10))
  
  w <- -natural1()
  expect_sinks(w, -Inf, 1)
  expect_true(has_sink(w))
  expect_false(has_sink(w, from = -10))
  
  # Numeric
  expect_sinks(1:10, numeric(), numeric())
  expect_sinks(as_discretes(1:10), numeric(), numeric())
  expect_false(has_sink(1:10))
  expect_false(has_sink(as_discretes(1:10)))
})

test_that("sinks - linear transform and dsct_keep", {
  x <- dsct_linear(integers(), m = 2, b = 1)
  expect_sinks(x, location = c(-Inf, Inf), direction = c(1, -1))

  y <- dsct_invert(natural1())
  y_keep <- dsct_keep(y, from = 0, include_from = FALSE)
  expect_sinks(y_keep, location = 0, direction = 1)

  y_drop <- dsct_keep(y, to = 0)
  expect_sinks(y_drop)
})

test_that("Inverse and union handles sinks properly.", {
  x <- 1 / integers()
  expect_true(has_sink(x, from = 0, to = 1))
  expect_true(has_sink(x, from = -1, to = 0))
  expect_equal(num_discretes(x, from = 1 / 5, to = 1), 5)
  expect_equal(num_discretes(x, from = -1, to = -1 / 5), 5)
  expect_equal(num_discretes(x, from = -0.001, to = 0.001), Inf)
  
  y_base <- dsct_union(
    0.5^natural1() - 5,
    1 / integers(),
    natural1(),
  )
  expect_sinks(y_base, c(-5, 0, 0, Inf), c(1, -1, 1, -1))
  expect_sinks(1 / y_base, c(-Inf, -0.2, 0, Inf), c(1, -1, 1, -1))
  expect_true(has_sink(y, to = -1000))
  expect_true(has_sink(y, from = 1000))
  expect_true(has_sink(y, from = -1, to = -0.1))
  expect_false(has_sink(y, from = -0.1, to = 0))
  expect_true(has_sink(y, from = 0, to = 0.1))
  
  z_base <- 1 / natural1()
  z <- dsct_union(z_base, -z_base, z_base + 1)
  expect_sinks(z, c(0, 0, 1), c(-1, 1, 1))
  expect_true(has_sink(z))
  expect_false(has_sink(z, 0.5, 1))
  expect_true(has_sink(z, to = 0))
  expect_true(has_sink(z, from = 1))
  
  expect_sinks(
    dsct_union(natural1(), -natural1()),
    location = c(-Inf, Inf),
    direction = c(1, -1)
  )
})

test_that("Transformations preserve sinks.", {
  x <- 1 / integers()
  y <- exp(x)
  expect_sinks(y, location = c(1, 1), direction = c(1, -1))
  expect_true(has_sink(y, from = 1, to = 2))
  expect_true(has_sink(y, from = 0.5, to = 1))
  expect_false(has_sink(y, from = 2))
  expect_false(has_sink(y, to = 0.5))
  expect_false(has_sink(y, to = 0))
  expect_false(has_sink(y, to = -1))
  
  x <- integers()
  y <- exp(x)
  expect_sinks(y, location = c(0, Inf), direction = c(1, -1))
  expect_true(has_sink(y))
  expect_true(has_sink(y, from = 1, to = 2))
  expect_true(has_sink(y, from = 0.5, to = 1))
  expect_false(has_sink(y, from = 2))
  expect_false(has_sink(y, to = 0.5))
  expect_false(has_sink(y, to = 0))
  expect_false(has_sink(y, to = -1))
  
  x <- 1 / natural1()
  expect_sinks(x, 0, 1)
  expect_true(has_sink(x))
  expect_false(has_sink(x, to = 0))
  
  x <- 0.5^natural1()
  expect_sinks(x, 0, 1)
  expect_true(has_sink(x))
  expect_false(has_sink(x, to = 0))
})

rm("expect_sinks")