test_that("+0 and -0 combined takes first instance.", {
  expect_equal(1 / as.numeric(dsct_union(0, -0)), Inf)
  expect_equal(1 / as.numeric(dsct_union(-0, 0)), -Inf)
  xboth1 <- dsct_union(arithmetic(-0, 1), arithmetic(0, 1))
  expect_equal(1 / as.numeric(xboth1, from = 0, to = 0), -Inf)
  xboth2 <- dsct_union(arithmetic(0, 1), arithmetic(-0, 1))
  expect_equal(1 / as.numeric(xboth2, from = 0, to = 0), Inf)
  # While a series containing only -0 and +0 has only one value,
  # the inverse of this series will have two: -Inf and Inf. This is because
  # all components of the discrete series remains intact until expression
  # as a vector via `as.numeric()`.
  expect_equal(as.numeric(1 / dsct_union(0, -0)), c(Inf, -Inf))
  
})
