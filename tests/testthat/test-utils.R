test_that("is_between works", {
  # Empty numeric
  expect_identical(is_between(numeric(), 0, 1), logical())
  # Finite bounds
  expect_identical(
    is_between(c(-1, 0, 0.5, 1, 2), 0, 1),
    c(FALSE, TRUE, TRUE, TRUE, FALSE)
  )
  expect_identical(
    is_between(c(0, 0.5, 1), 0, 1, include_lower = FALSE), 
    c(FALSE, TRUE, TRUE)
  )
  expect_identical(
    is_between(c(0, 0.5, 1), 0, 1, include_upper = FALSE), 
    c(TRUE, TRUE, FALSE)
  )
  expect_identical(
    is_between(
      c(0, 0.5, 1), 0, 1, include_lower = FALSE, include_upper = FALSE
    ), 
    c(FALSE, TRUE, FALSE)
  )
  # Infinite left bound
  expect_identical(
    is_between(c(-Inf, 0.5, 1, 2), -Inf, 1),
    c(TRUE, TRUE, TRUE, FALSE)
  )
  expect_identical(
    is_between(c(-Inf, 0.5, 1), -Inf, 1, include_lower = FALSE), 
    c(FALSE, TRUE, TRUE)
  )
  expect_identical(
    is_between(c(-Inf, 0.5, 1), -Inf, 1, include_upper = FALSE), 
    c(TRUE, TRUE, FALSE)
  )
  expect_identical(
    is_between(
      c(-Inf, 0.5, 1), -Inf, 1, include_lower = FALSE, include_upper = FALSE
    ), 
    c(FALSE, TRUE, FALSE)
  )
  # Infinite right bound
  expect_identical(
    is_between(c(Inf, 0.5, 0, -1), 0, Inf),
    c(TRUE, TRUE, TRUE, FALSE)
  )
  expect_identical(
    is_between(c(Inf, 0.5, 0), 0, Inf, include_lower = FALSE), 
    c(TRUE, TRUE, FALSE)
  )
  expect_identical(
    is_between(c(Inf, 0.5, 0), 0, Inf, include_upper = FALSE), 
    c(FALSE, TRUE, TRUE)
  )
  expect_identical(
    is_between(
      c(Inf, 0.5, 0), 0, Inf, include_lower = FALSE, include_upper = FALSE
    ), 
    c(FALSE, TRUE, FALSE)
  )
  # Infinite left and right bound
  expect_identical(
    is_between(c(Inf, 0.5, -Inf, -1), -Inf, Inf),
    c(TRUE, TRUE, TRUE, TRUE)
  )
  expect_identical(
    is_between(c(Inf, 0.5, -Inf), -Inf, Inf, include_lower = FALSE), 
    c(TRUE, TRUE, FALSE)
  )
  expect_identical(
    is_between(c(Inf, 0.5, -Inf), -Inf, Inf, include_upper = FALSE), 
    c(FALSE, TRUE, TRUE)
  )
  expect_identical(
    is_between(
      c(Inf, 0.5, -Inf), -Inf, Inf, include_lower = FALSE, include_upper = FALSE
    ), 
    c(FALSE, TRUE, FALSE)
  )
  # With NA
  expect_identical(
    is_between(c(-1, 0, 0.5, 1, 2, NA), 0, 1),
    c(FALSE, TRUE, TRUE, TRUE, FALSE, NA)
  )
})

test_that("Inputs to is_between() are checked.", {
  expect_error(is_between(0, -1, 1, include_lower = NA))
  expect_error(is_between(0, -1, 1, include_upper = NA))
  expect_error(is_between(0, -1, 1, include_lower = logical()))
  expect_error(is_between(0, -1, 1, include_upper = logical()))
  expect_error(is_between(0, -1, NA))
  expect_error(is_between(0, NA, 1))
  expect_error(is_between(0, numeric(), 1))
  expect_error(is_between(0, 1, numeric()))
})

test_that("floor2 and ceiling2 work.", {
  almost_six <- 6 - 1e-10
  expect_identical(floor2(almost_six), 6L)

  almost_seven <- 7 + 1e-10
  expect_identical(ceiling2(almost_seven), 7L)
  
  expect_identical(ceiling2(NA), NA_integer_)
  expect_identical(floor2(NA), NA_integer_)
  expect_identical(
    ceiling2(c(NA, almost_six, almost_seven)),
    c(NA_integer_, 6L, 7L)
  )
  expect_identical(
    floor2(c(NA, almost_six, almost_seven)),
    c(NA_integer_, 6L, 7L)
  )
})

test_that("as_integerish works.", {
  expect_identical(as_integerish(1e100), 1e100)
  expect_false(is.integer(as_integerish(1e100)))
  expect_identical(as_integerish(1e100 + 0.8), 1e100)
  expect_identical(as_integerish(-1e100 - 0.8), -1e100)
  
  x <- as_integerish(c(NA, 1, -5.5))
  expect_identical(x, c(NA_integer_, 1L, -5L))
  expect_true(is.integer(x))
  
  y <- as_integerish(c(NA, 1, -5.5, 1e100, Inf, -1e100, -Inf))
  expect_identical(y, c(NA_real_, 1, -5, 1e100, Inf, -1e100, -Inf))
  expect_false(is.integer(y))
  
  expect_identical(as_integerish(numeric()), integer())
})
