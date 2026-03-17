test_that("S3 methods for numeric work properly.", {
  # Inverse
  expect_identical(dsct_invert(-10:10), 1 / (-10:10))
  expect_identical(dsct_invert(NA_real_), NA_real_)
  # Linear
  expect_identical(dsct_linear(0:10, m = 1.5), 1.5 * (0:10))
  expect_identical(dsct_linear(0:10, m = 1.5, b = 0.1), 1.5 * (0:10) + 0.1)
  expect_identical(dsct_linear(0:10, m = numeric()), numeric())
  expect_identical(dsct_linear(0:10, m = numeric(), b = 0.1), numeric())
  expect_identical(dsct_linear(0:10, m = 1.5, b = numeric()), numeric())
  expect_identical(dsct_linear(0:10, m = numeric(), b = numeric()), numeric())
  expect_identical(dsct_linear(NA_real_, m = 1.5), NA_real_)
  expect_identical(dsct_linear(NA_real_, m = 1.5, b = 0.1), NA_real_)
  expect_error(dsct_linear(0:10, m = 0:10))
  expect_error(dsct_linear(0:10, m = 1, b = 0:10))
  # Negation
  expect_identical(dsct_negate(0:10), -(0:10))
  expect_identical(dsct_negate(NA_real_), NA_real_)
  # Transform
  expect_identical(
    dsct_transform(
      0:10,
      fun = function(x) x^2,
      inv = sqrt,
      domain = c(0, Inf),
      range = c(0, Inf)
    ),
    (0:10)^2
  )
  # as_discretes
  expect_s3_class(as_discretes(1:10), "discretes")
  expect_identical(get_discretes_in(as_discretes(1:10)), 1:10)
  expect_identical(as_discretes(integers()), integers())
  expect_error(as_discretes("hello"))
  expect_error(as_discretes(c("1", "2", "3")))
})
