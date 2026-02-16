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
  check_arith_signed_zero <- function(dsct, zro = c("pos", "neg", "none")) {
    zro <- match.arg(zro)
    pos <- expect_false
    neg <- expect_false
    if (zro == "pos") {
      pos <- expect_true
    }
    if (zro == "neg") {
      neg <- expect_true
    }
    pos(has_positive_zero(dsct))
    neg(has_negative_zero(dsct))
    pos(has_positive_zero(pluck_discretes(dsct, 0)))
    neg(has_negative_zero(pluck_discretes(dsct, 0)))
    pos(has_positive_zero(next_discrete(dsct, from = 0, include_from = TRUE)))
    neg(has_negative_zero(next_discrete(dsct, from = 0, include_from = TRUE)))
    pos(has_positive_zero(prev_discrete(dsct, from = 0, include_from = TRUE)))
    neg(has_negative_zero(prev_discrete(dsct, from = 0, include_from = TRUE)))
  }
  # Positive 0
  check_arith_signed_zero(arithmetic(0, 2), "pos")
  # Positive 0, not as representative
  check_arith_signed_zero(arithmetic(2, 2), "pos")
  # Negative 0
  check_arith_signed_zero(arithmetic(-0, 2), "neg")
  # Integers can't have -0:
  check_arith_signed_zero(arithmetic(-0L, 3L), "pos")
  # No zero at all:
  check_arith_signed_zero(arithmetic(1, 2), "none")
  # Negation
  check_arith_signed_zero(-arithmetic(0, 2), "neg")
  check_arith_signed_zero(-arithmetic(2, 2), "neg")
  check_arith_signed_zero(-arithmetic(-0, 2), "pos")
  check_arith_signed_zero(-arithmetic(0L, 3L), "pos")
  check_arith_signed_zero(-(1 * arithmetic(-0L, 3L)), "neg")
  check_arith_signed_zero(-arithmetic(1, 2), "none")
})

