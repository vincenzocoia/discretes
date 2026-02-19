test_that("Integers", {
  expect_equal(integers(2.2, 2.3), numeric(0))
  expect_equal(integers(2.2, 3), integers(3, 3))
  expect_equal(natural0(), integers(from = 0))
  expect_equal(natural1(), integers(from = 1))
})

test_that("Integers - bad inputs", {
  expect_error(integers(5, 2))
  expect_error(integers(5.5, 5.4))
  expect_error(integers(NA, 2))
  expect_error(integers(NA, NA))
  expect_error(integers(2, NA))
  expect_error(integers(from = Inf))
  expect_error(integers(to = -Inf))
  expect_error(integers(from = Inf, to = -Inf))
})

test_that("Integer sets match arithmetic series numerically", {
  expect_same_numbers <- function(x, y) {
    testthat::expect_identical(
      get_discretes_in(x, from = -10, to = 10),
      get_discretes_in(y, from = -10, to = 10)
    )
  }
  expect_same_numbers(integers(), arithmetic(0, 1))
  expect_same_numbers(natural0(), arithmetic(0, 1, n_left = 0))
  expect_same_numbers(natural1(), arithmetic(1, 1, n_left = 0))
  expect_same_numbers(integers(to = 0), arithmetic(0, 1, n_right = 0))
  expect_same_numbers(
    integers(-2, 5),
    arithmetic(0, 1, n_left = 2, n_right = 5)
  )
})
