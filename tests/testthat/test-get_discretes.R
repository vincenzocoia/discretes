test_that("get_discretes works", {
  x <- as_discretes(1:10)
  expect_identical(get_discretes_in(x), 1:10)
  expect_identical(get_discretes_in(x, from = 4, to = 7), 4:7)
  expect_identical(get_discretes_at(x, values = c(4, 5 + 1e-10, 7.1)), 4:5)
  expect_identical(as.numeric(x), as.double(1:10))
  
  y <- arithmetic(0, 1)
  expect_error(get_discretes_in(y))
  expect_error(as.numeric(y))
  expect_identical(get_discretes_in(y, from = 4, to = 7), as.double(4:7))
  expect_identical(
    get_discretes_at(y, values = c(4, 5 + 1e-10, 7.1)),
    as.double(4:5)
  )
  expect_identical(
    get_discretes_at(y, values = c(4, 5 + 1e-10, 7.1, NA)),
    c(4:5, NA_real_)
  )
})