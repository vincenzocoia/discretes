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
