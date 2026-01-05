test_that("arithmetic - bad inputs", {
  expect_error(arithmetic("5.5", 1.2))
  expect_error(arithmetic(NA, 1.2))
  expect_error(arithmetic(5.5, "1.2"))
  expect_error(arithmetic(5.5, -1.2))
  expect_error(arithmetic(5, NA))
  expect_error(arithmetic(5.5, 1.2, n_left = -3))
  expect_error(arithmetic(5.5, 1.2, n_left = "3"))
  expect_error(arithmetic(5.5, 1.2, n_left = NA))
  expect_error(arithmetic(5.5, 1.2, n_right = -3))
  expect_error(arithmetic(5.5, 1.2, n_right = NA))
  expect_error(arithmetic(5.5, 1.2, n_right = "3"))
})

test_that("integers", {
  expect_equal(integers(2.2, 2.3), numeric(0))
  expect_equal(integers(2.2, 3), integers(3, 3))

})

test_that("integers - bad inputs", {
  expect_error(integers(5, 2))
  expect_error(integers(5.5, 5.4))
  expect_error(integers(NA, 2))
  expect_error(integers(from = Inf))
  expect_error(integers(to = -Inf))
})
