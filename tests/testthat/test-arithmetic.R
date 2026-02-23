test_that("Numbers in an arithmetic set can match numeric vectors", {
  # Check that numbers between -10 and 10 match; `numbers` can spill over
  # the [-10, 10] range.
  expect_match <- function(x, numbers) {
    numbers <- numbers[numbers >= -10 & numbers <= 10]
    testthat::expect_equal(
      get_discretes_in(x, from = -10, to = 10),
      numbers
    )
  }
  expect_match(integers(), -10:10)
  expect_match(natural0(), 0:10)
  expect_match(natural1(), 1:10)
  expect_match(integers(to = 0), -10:0)
  expect_match(integers(-2, 5), -2:5)
  expect_match(arithmetic(0.5, 1.5), -10:10 * 1.5 + 0.5)
  expect_match(arithmetic(0.5, 1.5, n_right = 2), -10:2 * 1.5 + 0.5)
  expect_match(arithmetic(0.5, 1.5, n_left = 2), -2:10 * 1.5 + 0.5)
  expect_match(arithmetic(0.5, 1.5, n_right = 0), -10:0 * 1.5 + 0.5)
  expect_match(arithmetic(0.5, 1.5, n_left = 0), 0:10 * 1.5 + 0.5)
  expect_match(arithmetic(0.5, 1.5, n_left = 3, n_right = 2), -3:2 * 1.5 + 0.5)
})

test_that("Infinite n works for finite endpoints.", {
  expect_error(next_discrete(integers(), from = 0, n = Inf))
  expect_error(prev_discrete(integers(), from = 0, n = Inf))
  expect_error(next_discrete(integers(from = -10), from = 0, n = Inf))
  expect_error(prev_discrete(integers(to = 10), from = 0, n = Inf))
  # Upper endpoint
  upperend <- integers(to = 10)
  expect_identical(
    next_discrete(upperend, from = -3, n = Inf, include_from = TRUE),
    -3:10
  )
  expect_identical(
    next_discrete(upperend, from = -3, n = Inf, include_from = FALSE),
    -2:10
  )
  expect_identical(
    next_discrete(upperend, from = 3, n = Inf, include_from = TRUE),
    3:10
  )
  expect_identical(
    next_discrete(upperend, from = 3, n = Inf, include_from = FALSE),
    4:10
  )
  # Lower endpoint
  lowerend <- integers(from = -10)
  expect_identical(
    prev_discrete(lowerend, from = 3, n = Inf, include_from = TRUE),
    3:-10
  )
  expect_identical(
    prev_discrete(lowerend, from = 3, n = Inf, include_from = FALSE),
    2:-10
  )
  expect_identical(
    prev_discrete(lowerend, from = -3, n = Inf, include_from = TRUE),
    -3:-10
  )
  expect_identical(
    prev_discrete(lowerend, from = -3, n = Inf, include_from = FALSE),
    -4:-10
  )
})

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

test_that("Only one signed zero exists and is expressed properly.", {
  check_signed_zero <- function(dsct, zro = c("both", "pos", "neg", "none")) {
    zro <- match.arg(zro)
    pos <- expect_false
    neg <- expect_false
    if (zro == "pos" || zro == "both") {
      pos <- expect_true
    }
    if (zro == "neg" || zro == "both") {
      neg <- expect_true
    }
    pos(has_positive_zero(dsct))
    neg(has_negative_zero(dsct))
    pos(has_positive_zero(get_discretes_at(dsct, values = 0)))
    neg(has_negative_zero(get_discretes_at(dsct, values = 0)))
    pos(has_positive_zero(next_discrete(dsct, from = 0, include_from = TRUE)))
    neg(has_negative_zero(next_discrete(dsct, from = 0, include_from = TRUE)))
    pos(has_positive_zero(prev_discrete(dsct, from = 0, include_from = TRUE)))
    neg(has_negative_zero(prev_discrete(dsct, from = 0, include_from = TRUE)))
  }
  # Positive 0
  check_signed_zero(arithmetic(0, 2), "pos")
  # Positive 0, not as representative
  check_signed_zero(arithmetic(2, 2), "pos")
  # Negative 0
  check_signed_zero(arithmetic(-0, 2), "neg")
  # Integers can't have -0:
  check_signed_zero(arithmetic(-0L, 3L), "pos")
  # No zero at all:
  check_signed_zero(arithmetic(1, 2), "none")
  # Negation
  check_signed_zero(-arithmetic(0, 2), "neg")
  check_signed_zero(-arithmetic(2, 2), "neg")
  check_signed_zero(-arithmetic(-0, 2), "pos")
  check_signed_zero(-arithmetic(0L, 3L), "pos")
  check_signed_zero(-(1 * arithmetic(-0L, 3L)), "neg")
  check_signed_zero(-arithmetic(1, 2), "none")
})
