test_that("Negative zeroes are being tracked properly", {
  ## Via zeroes_vector()
  l0 <- discretes:::zeroes_vector(natural1())
  expect_length(l0, 0)
  
  plus <- discretes:::zeroes_vector(integers())
  expect_identical(1 / plus, Inf)
  
  minus <- discretes:::zeroes_vector(arithmetic(-0, 1))
  expect_identical(1 / minus, -Inf)
  
  plusminus <- discretes:::zeroes_vector(dsct_union(integers(), -0))
  expect_identical(sort(1 / plusminus), c(-Inf, Inf))
  
  ## Checking each S3 method
  ## --> arithmetic
  expect_identical(has_negative_zero(arithmetic(-0, 1)), TRUE)
  expect_identical(has_negative_zero(arithmetic(0, 1)), FALSE)
  expect_identical(has_positive_zero(arithmetic(-0, 1)), FALSE)
  expect_identical(has_positive_zero(arithmetic(0, 1)), TRUE)
  expect_identical(has_positive_zero(arithmetic(1, 1)), TRUE)
  ## --> inverse
  noneinf <- integers()
  posinf <- dsct_union(integers(), Inf)
  neginf <- dsct_union(integers(), -Inf)
  posneginf <- dsct_union(integers(), -Inf, Inf)
  expect_identical(has_negative_zero(1 / noneinf), FALSE)
  expect_identical(has_negative_zero(1 / posinf), FALSE)
  expect_identical(has_negative_zero(1 / neginf), TRUE)
  expect_identical(has_negative_zero(1 / posneginf), TRUE)
  expect_identical(has_positive_zero(1 / noneinf), FALSE)
  expect_identical(has_positive_zero(1 / posinf), TRUE)
  expect_identical(has_positive_zero(1 / neginf), FALSE)
  expect_identical(has_positive_zero(1 / posneginf), TRUE)
  ## --> union
  none <- dsct_union(natural1(), -natural1())
  pos <- dsct_union(none, 0)
  neg <- dsct_union(none, -0)
  posneg <- dsct_union(none, 0, -0)
  expect_identical(has_negative_zero(none), FALSE)
  expect_identical(has_positive_zero(none), FALSE)
  expect_identical(has_negative_zero(pos), FALSE)
  expect_identical(has_positive_zero(pos), TRUE)
  expect_identical(has_negative_zero(neg), TRUE)
  expect_identical(has_positive_zero(neg), FALSE)
  expect_identical(has_negative_zero(posneg), TRUE)
  expect_identical(has_positive_zero(posneg), TRUE)
  ## --> keep
  none_keep <- dsct_keep(none, from = -1)
  none_drop <- dsct_keep(none, from = 1)
  pos_keep <- dsct_keep(dsct_union(none, 0), from = -1)
  pos_drop <- dsct_keep(dsct_union(none, 0), from = 1)
  neg_keep <- dsct_keep(dsct_union(none, -0), from = -1)
  neg_drop <- dsct_keep(dsct_union(none, -0), from = 1)
  posneg_keep <- dsct_keep(dsct_union(none, 0, -0), from = -1)
  posneg_drop <- dsct_keep(dsct_union(none, 0, -0), from = 1)
  expect_identical(has_negative_zero(none_keep), FALSE)
  expect_identical(has_positive_zero(none_keep), FALSE)
  expect_identical(has_negative_zero(none_drop), FALSE)
  expect_identical(has_positive_zero(none_drop), FALSE)
  expect_identical(has_negative_zero(pos_keep), FALSE)
  expect_identical(has_positive_zero(pos_keep), TRUE)
  expect_identical(has_negative_zero(pos_drop), FALSE)
  expect_identical(has_positive_zero(pos_drop), FALSE)
  expect_identical(has_negative_zero(neg_keep), TRUE)
  expect_identical(has_positive_zero(neg_keep), FALSE)
  expect_identical(has_negative_zero(neg_drop), FALSE)
  expect_identical(has_positive_zero(neg_drop), FALSE)
  expect_identical(has_negative_zero(posneg_keep), TRUE)
  expect_identical(has_positive_zero(posneg_keep), TRUE)
  expect_identical(has_negative_zero(posneg_drop), FALSE)
  expect_identical(has_positive_zero(posneg_drop), FALSE)
  ## --> linear
  nonev <- get_discretes_in(none, from = -10, to = 10)
  posv <- c(nonev, 0)
  negv <- c(nonev, -0)
  posnegv <- c(nonev, -0, 0)
  # Check that linear transforms induce signed zero like it would for a numeric
  # vector: supply the slope (m) and intercept (b), and check that the
  # numeric version of the "discretes" reference object behaves in the same
  # way (just make sure the numeric version extends left and right "far enough"
  # to encompass zero for each m and b chosen).
  check_mb <- function(dsct, dbl, m, b = NULL) {
    if (is.null(b)) {
      testthat::expect_identical(
        has_positive_zero(m * dsct),
        has_positive_zero(m * dbl)
      )
      testthat::expect_identical(
        has_negative_zero(m * dsct),
        has_negative_zero(m * dbl)
      )
      return(invisible(NULL))
    }
    testthat::expect_identical(
      has_positive_zero(m * dsct + b),
      has_positive_zero(m * dbl + b)
    )
    testthat::expect_identical(
      has_negative_zero(m * dsct + b),
      has_negative_zero(m * dbl + b)
    )
    invisible(NULL)
  }
  ## m
  check_mb(none,   nonev,   m = 0)
  check_mb(pos,    posv,    m = 0)
  check_mb(neg,    negv,    m = 0)
  check_mb(posneg, posnegv, m = 0)

  check_mb(none,   nonev,   m = -0)
  check_mb(pos,    posv,    m = -0)
  check_mb(neg,    negv,    m = -0)
  check_mb(posneg, posnegv, m = -0)

  check_mb(none,   nonev,   m = 2)
  check_mb(pos,    posv,    m = 2)
  check_mb(neg,    negv,    m = 2)
  check_mb(posneg, posnegv, m = 2)

  check_mb(none,   nonev,   m = -2)
  check_mb(pos,    posv,    m = -2)
  check_mb(neg,    negv,    m = -2)
  check_mb(posneg, posnegv, m = -2)

  ## b
  check_mb(none,   nonev,   m = 1, b = 0)
  check_mb(pos,    posv,    m = 1, b = 0)
  check_mb(neg,    negv,    m = 1, b = 0)
  check_mb(posneg, posnegv, m = 1, b = 0)

  check_mb(none,   nonev,   m = 1, b = -0)
  check_mb(pos,    posv,    m = 1, b = -0)
  check_mb(neg,    negv,    m = 1, b = -0)
  check_mb(posneg, posnegv, m = 1, b = -0)

  check_mb(none,   nonev,   m = 1, b = 2)
  check_mb(pos,    posv,    m = 1, b = 2)
  check_mb(neg,    negv,    m = 1, b = 2)
  check_mb(posneg, posnegv, m = 1, b = 2)

  check_mb(none,   nonev,   m = 1, b = -2)
  check_mb(pos,    posv,    m = 1, b = -2)
  check_mb(neg,    negv,    m = 1, b = -2)
  check_mb(posneg, posnegv, m = 1, b = -2)

  ## m, b
  check_mb(none,   nonev,   m = 0,  b = 0)
  check_mb(pos,    posv,    m = 0,  b = 0)
  check_mb(neg,    negv,    m = 0,  b = 0)
  check_mb(posneg, posnegv, m = 0,  b = 0)

  check_mb(none,   nonev,   m = -0, b = 0)
  check_mb(pos,    posv,    m = -0, b = 0)
  check_mb(neg,    negv,    m = -0, b = 0)
  check_mb(posneg, posnegv, m = -0, b = 0)

  check_mb(none,   nonev,   m = 0,  b = -0)
  check_mb(pos,    posv,    m = 0,  b = -0)
  check_mb(neg,    negv,    m = 0,  b = -0)
  check_mb(posneg, posnegv, m = 0,  b = -0)

  check_mb(none,   nonev,   m = -0, b = -0)
  check_mb(pos,    posv,    m = -0, b = -0)
  check_mb(neg,    negv,    m = -0, b = -0)
  check_mb(posneg, posnegv, m = -0, b = -0)

  check_mb(none,   nonev,   m = 2,  b = 0)
  check_mb(pos,    posv,    m = 2,  b = 0)
  check_mb(neg,    negv,    m = 2,  b = 0)
  check_mb(posneg, posnegv, m = 2,  b = 0)

  check_mb(none,   nonev,   m = -2, b = 0)
  check_mb(pos,    posv,    m = -2, b = 0)
  check_mb(neg,    negv,    m = -2, b = 0)
  check_mb(posneg, posnegv, m = -2, b = 0)

  check_mb(none,   nonev,   m = 2,  b = -0)
  check_mb(pos,    posv,    m = 2,  b = -0)
  check_mb(neg,    negv,    m = 2,  b = -0)
  check_mb(posneg, posnegv, m = 2,  b = -0)

  check_mb(none,   nonev,   m = -2, b = -0)
  check_mb(pos,    posv,    m = -2, b = -0)
  check_mb(neg,    negv,    m = -2, b = -0)
  check_mb(posneg, posnegv, m = -2, b = -0)

  check_mb(none,   nonev,   m = 0,  b = 2)
  check_mb(pos,    posv,    m = 0,  b = 2)
  check_mb(neg,    negv,    m = 0,  b = 2)
  check_mb(posneg, posnegv, m = 0,  b = 2)

  check_mb(none,   nonev,   m = -0, b = 2)
  check_mb(pos,    posv,    m = -0, b = 2)
  check_mb(neg,    negv,    m = -0, b = 2)
  check_mb(posneg, posnegv, m = -0, b = 2)

  check_mb(none,   nonev,   m = 0,  b = -2)
  check_mb(pos,    posv,    m = 0,  b = -2)
  check_mb(neg,    negv,    m = 0,  b = -2)
  check_mb(posneg, posnegv, m = 0,  b = -2)

  check_mb(none,   nonev,   m = -0, b = -2)
  check_mb(pos,    posv,    m = -0, b = -2)
  check_mb(neg,    negv,    m = -0, b = -2)
  check_mb(posneg, posnegv, m = -0, b = -2)

  check_mb(none,   nonev,   m = 2,  b = 2)
  check_mb(pos,    posv,    m = 2,  b = 2)
  check_mb(neg,    negv,    m = 2,  b = 2)
  check_mb(posneg, posnegv, m = 2,  b = 2)

  check_mb(none,   nonev,   m = -2, b = 2)
  check_mb(pos,    posv,    m = -2, b = 2)
  check_mb(neg,    negv,    m = -2, b = 2)
  check_mb(posneg, posnegv, m = -2, b = 2)

  check_mb(none,   nonev,   m = 2,  b = -2)
  check_mb(pos,    posv,    m = 2,  b = -2)
  check_mb(neg,    negv,    m = 2,  b = -2)
  check_mb(posneg, posnegv, m = 2,  b = -2)

  check_mb(none,   nonev,   m = -2, b = -2)
  check_mb(pos,    posv,    m = -2, b = -2)
  check_mb(neg,    negv,    m = -2, b = -2)
  check_mb(posneg, posnegv, m = -2, b = -2)

  ## --> negation
  expect_identical(has_negative_zero(-none), FALSE)
  expect_identical(has_positive_zero(-none), FALSE)
  expect_identical(has_negative_zero(-pos), TRUE)
  expect_identical(has_positive_zero(-pos), FALSE)
  expect_identical(has_negative_zero(-neg), FALSE)
  expect_identical(has_positive_zero(-neg), TRUE)
  expect_identical(has_negative_zero(-posneg), TRUE)
  expect_identical(has_positive_zero(-posneg), TRUE)
  ## --> transform
  none_tanh <- dsct_transform(none, fun = tanh, inv = atanh)
  pos_tanh <- dsct_transform(pos, fun = tanh, inv = atanh)
  neg_tanh <- dsct_transform(neg, fun = tanh, inv = atanh)
  posneg_tanh <- dsct_transform(posneg, fun = tanh, inv = atanh)
  expect_identical(has_negative_zero(none_tanh), FALSE)
  expect_identical(has_positive_zero(none_tanh), FALSE)
  expect_identical(has_negative_zero(pos_tanh), has_negative_zero(tanh(0)))
  expect_identical(has_positive_zero(pos_tanh), has_positive_zero(tanh(0)))
  expect_identical(has_negative_zero(neg_tanh), has_negative_zero(tanh(-0)))
  expect_identical(has_positive_zero(neg_tanh), has_positive_zero(tanh(-0)))
  expect_identical(
    has_negative_zero(posneg_tanh),
    has_negative_zero(tanh(c(0, -0)))
  )
  expect_identical(
    has_positive_zero(posneg_tanh),
    has_positive_zero(tanh(c(0, -0)))
  )
  ## --> numeric
  expect_identical(has_negative_zero(1), FALSE)
  expect_identical(has_negative_zero(-0), TRUE)
  expect_identical(has_negative_zero(0), FALSE)
  expect_identical(has_negative_zero(c(0, -0)), TRUE)
  expect_identical(has_positive_zero(1), FALSE)
  expect_identical(has_positive_zero(-0), FALSE)
  expect_identical(has_positive_zero(0), TRUE)
  expect_identical(has_positive_zero(c(0, -0)), TRUE)
})
