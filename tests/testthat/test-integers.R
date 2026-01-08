test_that("integers", {
  expect_equal(integers(2.2, 2.3), numeric(0))
  expect_equal(integers(2.2, 3), integers(3, 3))
})

test_that("integers - bad inputs", {
  expect_error(integers(5, 2))
  expect_error(integers(5.5, 5.4))
  expect_error(integers(NA, 2))
  expect_error(integers(NA, NA))
  expect_error(integers(2, NA))
  expect_error(integers(from = Inf))
  expect_error(integers(to = -Inf))
  expect_error(integers(from = Inf, to = -Inf))
})

test_that("Natural numbers", {
  expect_equal(natural0(), integers(from = 0))
  expect_equal(natural1(), integers(from = 1))
})
