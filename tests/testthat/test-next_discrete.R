test_that("next discrete - arithmetic", {
  x1 <- arithmetic(0, 0.8)
  x2 <- arithmetic(0, 0.8, n_left = 0)
  x3 <- arithmetic(0, 0.8, n_right = 0)
  x4 <- arithmetic(0, 0.8, n_left = 0, n_right = 0)
})
