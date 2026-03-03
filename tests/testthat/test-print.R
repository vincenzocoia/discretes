test_that("print.discretes - empty series", {
  out <- capture.output(print(as_discretes(numeric())))
  expect_match(paste(out, collapse = "\n"), "Empty series")
})

test_that("print.discretes - finite series", {
  x <- as_discretes(1:10)
  out <- capture.output(print(x))
  expect_match(paste(out, collapse = "\n"), "length 10")
  expect_match(paste(out, collapse = "\n"), "1.*10")
  out2 <- capture.output(print(x, len = 0))
  expect_match(paste(out2, collapse = "\n"), "length 10")
  out3 <- capture.output(print(x, len = 3))
  expect_match(paste(out3, collapse = "\n"), "\\.\\.\\.")
})

test_that("print.discretes - finite series with len = 1", {
  x <- as_discretes(c(1, 2, 3))
  out <- capture.output(print(x, len = 1))
  expect_match(paste(out, collapse = "\n"), "length 3")
})

test_that("print.discretes - infinite series", {
  x <- integers()
  out <- capture.output(print(x))
  expect_match(paste(out, collapse = "\n"), "length")
  out2 <- capture.output(print(x, len = 1))
  expect_true(length(out2) >= 1L)
  out3 <- capture.output(print(x, len = 0))
  expect_match(paste(out3, collapse = "\n"), "length")
})

test_that("print.discretes - infinite one-sided (natural numbers)", {
  x <- natural1()
  out <- capture.output(print(x, len = 4))
  expect_match(paste(out, collapse = "\n"), "\\.\\.\\.|length")
})

test_that("print.discretes - infinite both sides with len = 1", {
  x <- 1 / integers()
  out <- capture.output(print(x, len = 1))
  expect_true(length(out) >= 1L)
})

test_that("print.discretes returns input invisibly", {
  x <- as_discretes(1:3)
  expect_identical(withVisible(print(x))$value, x)
  expect_false(withVisible(print(x))$visible)
})
