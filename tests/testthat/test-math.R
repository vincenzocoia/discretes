test_that("Edge cases", {
  expect_error(sign(integers()))
  expect_error(abs(integers()))
  expect_error(exp(integers(), goes_in_ellipsis = 0))
})
