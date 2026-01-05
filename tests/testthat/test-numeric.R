test_that("Discrete-testing works for numeric discretes.", {
  x <- c(4.2, 6.5, -4.4, -4.4, 4.2, 10)
  expect_equal(
    test_discrete(x, c(NA, 6.5, 6, Inf, -Inf)),
    c(NA, TRUE, FALSE, FALSE, FALSE)
  )
  expect_equal(test_discrete(x, numeric()), logical(0))
})
