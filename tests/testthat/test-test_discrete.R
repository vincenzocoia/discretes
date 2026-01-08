test_that("NA, Inf, and empty values with test_discrete.", {
  # arithmetic
  x <- arithmetic(5.5, 1.2, n_left = 3, n_right = 4)
  expect_identical(
    test_discrete(x, c(NA, 6.7, 6, Inf, -Inf)),
    c(NA, TRUE, FALSE, FALSE, FALSE)
  )
  expect_identical(test_discrete(x, numeric()), logical())
  # numeric
  y <- c(1.2, 3.4, 5.6, 3.4)
  expect_equal(
    test_discrete(y, c(NA, 3.4, 4.5, Inf, -Inf)),
    c(NA, TRUE, FALSE, FALSE, FALSE)
  )
})

test_that("edge cases - numeric", {
  y <- c(1.2, -4.4, NA)
  expect_equal(test_discrete(y, NA), NA)
  expect_equal(test_discrete(y, c(NA, -4.4, Inf)), c(NA, NA, NA))
  y <- numeric(0)
  expect_equal(test_discrete(y, NA), FALSE)
  expect_equal(test_discrete(y, c(NA, 4.4, Inf)), c(FALSE, FALSE, FALSE))
  expect_equal(test_discrete(y, 1:3), c(FALSE, FALSE, FALSE))
})
