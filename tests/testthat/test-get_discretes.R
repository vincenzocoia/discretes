test_that("", {
  x <- as_discretes(1:10)
  expect_equal(get_discretes_in(x), as.numeric(x))
  expect_true(is.integer(get_discretes_in(x)))
  expect_false(is.integer(as.numeric(x)))
})

test_that("Get discretes: edge cases.", {
  expect_error(get_discretes_in(integers()))
  expect_error(as.numeric(integers()))
})